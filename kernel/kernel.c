void kernel_main() {
    char *video_memory = (char*) 0xb8000;
    const char *str = "Hello, Kernel World!";
    unsigned int i = 0;
    while (str[i] != '\0') {
        video_memory[i * 2] = str[i];
        video_memory[i * 2 + 1] = 0x07; // Atributo de cor: branco no fundo preto
        i++;
    }
    while (1) {
        // Loop infinito para manter o kernel em execução
    }
}
