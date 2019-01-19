package com.alphas.product.controller;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
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
	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());
	@Autowired
	private ProductService service;
	
	@GetMapping(value = "/add")
	public String showAddProduct(Model model) {
		Product product = new Product();
		model.addAttribute("product", product);
		model.addAttribute("pageView","product/add");
		return "common/template";
	}

	
	@GetMapping(value = "/{id}/update")
	public String showUpdateProduct(@PathVariable("id") Long id, Model model, final RedirectAttributes redirectAttributes) {
		try {
		Product product = service.findById(id);
		model.addAttribute("product", product);
		model.addAttribute("pageView","product/add");
		}catch(AException a) {
			LOGGER.error(a.getMessage(), a);
			redirectAttributes.addAttribute("error", "Unable to fetch the Product information. Please contact support.");
		}
		return "common/template";
	}
	
	
	@PostMapping(path = "/save")
	public String save(@RequestParam("files") MultipartFile[] files, @ModelAttribute("product") Product product, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		
		try {
			product.setImages();
			
			if(product.getId() == null) {
				redirectAttributes.addFlashAttribute("msg", "The Product "+product.getName()+" added successfully!");
			}else {
				redirectAttributes.addFlashAttribute("msg", "The Product "+product.getName()+" updated successfully!");
			}
			
			service.add(product);
			
			model.addAttribute("product",result);
		}
		
		
		catch(IOException | NoSuchFieldException | SecurityException | IllegalArgumentException | IllegalAccessException e) {
			LOGGER.error(e.getMessage(), e);
			redirectAttributes.addFlashAttribute("error","Problem while saving the image");
		}
		catch (AException e) {
			LOGGER.error(e.getMessage(), e);
			redirectAttributes.addFlashAttribute("error",e.getMessage());
		}
		//model.addAttribute("pageView","/add");
		return "redirect:add";
	}
	
		
	
	@GetMapping("/list")
	public String retrieve(Model model) {
		try {
			model.addAttribute("products",service.retrieveAll());
		} catch (AException e) {
			
		}
		model.addAttribute("pageView","product/list");
		return "common/template";
	}
}
