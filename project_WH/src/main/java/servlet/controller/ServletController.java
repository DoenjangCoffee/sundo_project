package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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
	
	@RequestMapping(value = "/upfile.do", method = RequestMethod.POST)
	public @ResponseBody void upload(@RequestParam("uFile") MultipartFile upfile) throws IOException {
		servletService.deleteDB();
		
		System.out.println(upfile.getName());
		System.out.println(upfile.getContentType());
		System.out.println(upfile.getSize());
		
		List<Map<String, Object>>list = new ArrayList<>();
		InputStreamReader isr = new InputStreamReader(upfile.getInputStream());
		BufferedReader br = new BufferedReader(isr);
		
		String line = null;
		while ((line = br.readLine()) != null) {
			Map<String, Object> m = new HashMap<>();
			String[] lineArr = line.split("\\|");
			//m.put("date",			lineArr[0]); //사용_년월			date
			m.put("site", 			lineArr[1]); //대지_위치			addr
			//m.put("newAddr", 		lineArr[2]); //도로명_대지_위치		newAddr
			m.put("sgg_cd",			lineArr[3]); //시군구_코드			sigungu
			m.put("bjd_cd",			lineArr[4]); //법정동_코드			bubjungdong
			//m.put("addrCode", 		lineArr[5]); //대지_구분_코드		addrCode
			//m.put("bun", 			lineArr[6]); //번					bun
			//m.put("si",				lineArr[7]); //지					si
			//m.put("newAddrCode",	lineArr[8]); //새주소_일련번호		newAddrCode
			//m.put("newAddr", 		lineArr[9]); //새주소_도로_코드	newAddr
			//m.put("newAddrUnder", 	lineArr[10]); //새주소_지상지하_코드newAddrUnder
			//m.put("newAddrBun",		lineArr[11]); //새주소_본_번		newAddrBun
			//m.put("newAddrBun2",	lineArr[12]); //새주소_부_번		newAddrBun2
			m.put("usekwh",			lineArr[13]==""?0:Integer.parseInt(lineArr[13])); //사용_량(KWh)		usekwh

			list.add(m);			
		}
		servletService.fileUp(list);
		br.close();
		isr.close();
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
