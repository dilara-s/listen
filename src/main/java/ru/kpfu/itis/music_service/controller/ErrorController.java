package ru.kpfu.itis.music_service.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/error")
public class ErrorController {

    @GetMapping("/404")
    public String handleNotFound(HttpServletRequest request, Model model) {
        model.addAttribute("url", request.getAttribute("javax.servlet.error.request_uri"));
        return "error/404";
    }

    @GetMapping("/403")
    public String handleForbidden(HttpServletRequest request, Model model) {
        model.addAttribute("url", request.getAttribute("javax.servlet.error.request_uri"));
        return "error/403";
    }

    @GetMapping("/500")
    public String handleServerError(HttpServletRequest request, Model model) {
        model.addAttribute("url", request.getAttribute("javax.servlet.error.request_uri"));
        model.addAttribute("exception", request.getAttribute("javax.servlet.error.exception"));
        return "error/500";
    }
} 