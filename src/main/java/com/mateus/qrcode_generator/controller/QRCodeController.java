package com.mateus.qrcode_generator.controller;

import com.mateus.qrcode_generator.service.QRCodeService;
import com.google.zxing.WriterException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import java.io.IOException;


import java.util.Base64;

@Controller
public class QRCodeController {

    @Autowired
    private QRCodeService qrCodeService;

    // 1. Endpoint para a página inicial (formulário)
    @GetMapping("/")
    public String index() {
        return "index"; // Retorna o template Thymeleaf "index.html"
    }

    // 2. Endpoint para gerar e exibir a imagem do QR Code
    @ResponseBody // Indica que o retorno será o corpo da resposta HTTP (a imagem)
    @GetMapping(value = "/generate", produces = MediaType.IMAGE_PNG_VALUE)
    public byte[] generateQRCode(@RequestParam String text,
                                 @RequestParam(defaultValue = "200") int width,
                                 @RequestParam(defaultValue = "200") int height) throws WriterException, IOException {

        // Chama o serviço para gerar o QR Code
        return qrCodeService.generateQRCodeImage(text, width, height);
    }
}