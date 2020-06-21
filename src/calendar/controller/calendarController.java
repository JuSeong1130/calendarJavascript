package calendar.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.google.gson.Gson;

@WebServlet("/calendar/*")
public class calendarController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		execute(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		execute(req, resp);
	}

	protected void execute(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String path = req.getRequestURI();
		// 요청 URI
		path = path.substring(path.lastIndexOf("/") + 1);
		System.out.println(path);
		String next = "";
		List<String> object = new ArrayList<String>();
		resp.setContentType("text/html;charset=UTF-8");
		PrintWriter out = resp.getWriter();

		if (path.equals("calendar")) {
			next = "calendarview/calendar_view.jsp";
		} else {
             
			int start_year = Integer.parseInt(req.getParameter("start_year"));
			int start_month =  Integer.parseInt(req.getParameter("start_month"));
			int end_year =  Integer.parseInt(req.getParameter("end_year"));
			int end_month =  Integer.parseInt(req.getParameter("end_month"));
			
			try {
				object = getHoliday(start_year, start_month, end_year, end_month);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		if (next != "") {
			RequestDispatcher dis = req.getRequestDispatcher(next);
			dis.forward(req, resp);
		}
		Gson gson = new Gson();
		out.print(gson.toJson(object, List.class));
		out.flush();

	}

	public List<String> getHoliday(int start_year, int start_month, int end_year, int end_month) throws Exception {
		
		DocumentBuilderFactory dbFactoty = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactoty.newDocumentBuilder();
		Document doc = null;
		List<String> holiday = new ArrayList<String>();
		XPath xpath = XPathFactory.newInstance().newXPath(); // xpath 생성
	
		for (int i = start_year; i <= end_year; i++) {
			int month = 0;
			if (i == end_year) {
				month = end_month;
			} else {
				month = 12;
			}
             System.out.println("month는"+month);
			for (int j = start_month; j <= month; j++) {

				StringBuilder urlBuilder = new StringBuilder(
						"http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getHoliDeInfo"); /* URL */
				urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8")
				+ "=SLItNg33woo23x0ctun4UI6ISbXgYXD1%2BnHeEJPgQqRYwNNPrmx43OI0EY7lodgCrvFqKa9LcoTyuo%2B3eKfkKQ%3D%3D");

				urlBuilder.append("&" + URLEncoder.encode("solYear", "UTF-8") + "="
						+ URLEncoder.encode(String.valueOf(i), "UTF-8"));
				
				String crm =String.valueOf(j).length() == 2 ? String.valueOf(j) : '0' + String.valueOf(j);
				urlBuilder.append("&" + URLEncoder.encode("solMonth", "UTF-8") + "="
						+ URLEncoder.encode(crm, "UTF-8"));
				doc = dBuilder.parse(urlBuilder.toString());
				System.out.println("url"+urlBuilder.toString());
				doc.getDocumentElement().normalize();
				NodeList nList = (NodeList) xpath.evaluate("//response/body/items/item/locdate", doc,
						XPathConstants.NODESET);
				for (int d = 0; d < nList.getLength(); d++) {
					String contents = nList.item(d).getTextContent();
					holiday.add(contents);
					System.out.println("java공휴일은"+contents);
				}
			}
			start_month = 1;
		}

		return holiday;
	}
}
