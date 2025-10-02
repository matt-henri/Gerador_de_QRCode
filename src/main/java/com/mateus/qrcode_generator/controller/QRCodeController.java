package com.mateus.qrcode_generator.controller;

import com.mateus.qrcode_generator.service.QRCodeService;
import com.google.zxing.WriterException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import java.io.IOException;




@Controller
public class QRCodeController {

    @Autowired
    private QRCodeService qrCodeService; // Variável injetada

    // 1. Endpoint para a página inicial (formulário)
    @GetMapping("/")
    public String index() {
        return "index"; // Retorna o template Thymeleaf "index.html"
    }

    // 2. Endpoint para gerar e exibir a imagem do QR Code
    @ResponseBody
    @GetMapping(value = "/generate", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> generateQrCode(
            @RequestParam("text") String text,
            @RequestParam("width") int width,
            @RequestParam("height") int height) {

        // Use o nome correto da variável injetada: 'qrCodeService'
        byte[] qrCodeBytes = qrCodeService.generate(text, width, height);

        // 2. Retorna os bytes com o status OK e o Content-Type correto
        return ResponseEntity.ok().body(qrCodeBytes);
    }
}