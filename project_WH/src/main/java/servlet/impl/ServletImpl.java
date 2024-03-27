package servlet.impl;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.service.ServletService;

@Service("ServletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	
	@Override
	public String addStringTest(String str) throws Exception {
		List<EgovMap> mediaType = dao.selectAll();
		return str + " -> testImpl ";
	}

	@Override
	public List<Map<String, Object>> si() {
		return dao.selectList("si");
	}

	@Override
	public List<Map<String, Object>> sgg(String sido) {
		return dao.selectList("sgg",sido);
	}

	@Override
	public List<Map<String, Object>> bjd(String gu) {
		return dao.selectList("bjd", gu);
	}

	@Override
	public void fileUp(List<Map<String, Object>> list) {
			dao.insert("fileUp", list);
		}
		

	


}
