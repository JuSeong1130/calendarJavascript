package calendar.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;


public class holidayService {

	
	public static void main(String[] args) throws Exception {
		   
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getHoliDeInfo"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=SLItNg33woo23x0ctun4UI6ISbXgYXD1%2BnHeEJPgQqRYwNNPrmx43OI0EY7lodgCrvFqKa9LcoTyuo%2B3eKfkKQ%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("solYear","UTF-8") + "=" + URLEncoder.encode("2020", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("solMonth","UTF-8") + "=" + URLEncoder.encode("12", "UTF-8")); 
        System.out.println(urlBuilder.toString());
		
        DocumentBuilderFactory dbFactoty = DocumentBuilderFactory.newInstance();
        DocumentBuilder dBuilder = dbFactoty.newDocumentBuilder();
        Document doc = dBuilder.parse(urlBuilder.toString());
        
        doc.getDocumentElement().normalize();
		System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
		
		  XPath xpath = XPathFactory.newInstance().newXPath(); // xpath 생성
		  
		  // NodeList 가져오기
		  NodeList nList = (NodeList) xpath.evaluate("//response/body/items/item/locdate", doc, XPathConstants.NODESET);
		  System.out.println("파싱할 리스트 수 : "+ nList.getLength()); // 파싱할 리스트 수
		  
		  //출력
		  List<String> holiday = new ArrayList<String>();
		  for(int i = 0 ; i < nList.getLength() ; i++){ 
			  String contents =
		  nList.item(i).getTextContent(); 
			  holiday.add(contents);
			  System.out.println(contents); 
			  
		  }

		  }
		  
		  
		  
		 
        
	}
	
	

