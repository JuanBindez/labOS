[BITS 16]
[ORG 0x7C00]

start:
    cli                 ; Desativa interrupções
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Configura a pilha

    ; Carregar o kernel (assumindo que está no setor 2 da imagem de disco)
    mov bx, 0x1000      ; Endereço de carregamento do kernel
    mov dh, 0           ; Cabeça
    mov dl, 0           ; Unidade (0 = A:, 1 = B:)
    mov ch, 0           ; Cilindro
    mov cl, 2           ; Setor (setores começam em 1)
    mov ah, 2           ; Função de leitura de setores
    mov al, 1           ; Número de setores para ler
    int 0x13            ; Chamar BIOS para ler setor

    jc disk_error       ; Se erro, vai para disk_error

    ; Pular para o kernel
    jmp 0x1000:0000

disk_error:
    ; Exibir mensagem de erro e parar
    mov si, error_msg
print_error:
    lodsb
    or al, al
    jz halt
    mov ah, 0x0E
    int 0x10
    jmp print_error

halt:
    hlt
    jmp halt

error_msg db 'Erro ao carregar o kernel', 0

times 510-($-$$) db 0
dw 0xAA55
