package servlet.service;

import java.util.List;
import java.util.Map;

public interface ServletService {
	String addStringTest(String str) throws Exception;

	List<Map<String, Object>> si();

	List<Map<String, Object>> sgg(String sido);

	List<Map<String, Object>> bjd(String gu);

	void fileUp(List<Map<String, Object>> list);

	void deleteDB();
}
