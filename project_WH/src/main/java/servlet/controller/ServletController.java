package servlet.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.service.ServletService;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@RequestMapping(value = "/main.do",method = RequestMethod.GET)
	public String mainTest(ModelMap model) throws Exception {
		List<Map<String, Object>>si = servletService.si();
		//String str = servletService.addStringTest("START! ");
		model.addAttribute("si", si);
		//model.addAttribute("resultStr", str);
		
		return "main/main";
	}
	
	@RequestMapping(value="/ggTest.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> ggTest(@RequestParam("sido") String sido){
		//System.out.println(sido);
		List<Map<String, Object>> sgg = servletService.sgg(sido);
			//System.out.println("확인"+sgg);
			return sgg;
	}
	
	@RequestMapping(value = "/bjdTest.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> bjdTest(@RequestParam("gu") String gu){
		System.out.println(gu);
		List<Map<String, Object>>bjd = servletService.bjd(gu);
		System.out.println(bjd);
		return bjd;
	}
	
	@RequestMapping(value = "/upLoad.do", method = RequestMethod.GET)
	public String upLoad() {
		
		return "main/upLoad";
	}
	
	@RequestMapping(value = "/statistic.do", method = RequestMethod.GET)
	public String statistic() {
		return "main/statistic";
	}
	
	@RequestMapping(value = "/cMap.do", method = RequestMethod.GET)
	public String cMap(Model model) {
		List<Map<String, Object>>si	= servletService.si();
		model.addAttribute("si", si);
		return "main/cmap";
	}
	
	@RequestMapping(value="/test.do")
	public String test () {
		return "main/test";
	}
}
