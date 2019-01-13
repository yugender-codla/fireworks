package com.alphas.product.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alphas.common.exception.AException;
import com.alphas.product.dto.Product;
import com.alphas.product.service.ProductService;


@Controller
@RequestMapping("/product")
public class ProductController {

	@Autowired
	private ProductService service;
	
	@GetMapping(value = "/add")
	public String showAddUserForm(Model model) {
		Product product = new Product();
		model.addAttribute("product", product);
		return "product/add";
	}

	@PostMapping(path = "/save")
	public String save(@RequestParam("files") MultipartFile[] files, @ModelAttribute("product") Product product, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		
		try {
			product.setImages();
			service.add(product);
			redirectAttributes.addFlashAttribute("msg", "The Product "+product.getName()+" added successfully!");
			model.addAttribute("product",result);
			
		}
		
		catch(IOException | NoSuchFieldException | SecurityException | IllegalArgumentException | IllegalAccessException e) {
			redirectAttributes.addFlashAttribute("error","Problem while saving the image");
		}
		catch (AException e) {
			redirectAttributes.addFlashAttribute("error",e.getMessage());
		}
		return "redirect:/product/add/";
	}
	
	@GetMapping("/retrieveAll")
	public String retrieveAll(Model model) {
		try {
			model.addAttribute("products",service.retrieveAll());
		} catch (AException e) {
			
		}
		return "product/list";
	}
}
