<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"
></script>
</head>


<style>
* {
	margin: 0px;
	padding: 0px;
}

/* 						$('#calendar').find('tr').find('td').css('background','#e1d3f5') */
/* 						$('#calendar').find('tr').eq(0).find('td').css('background','#9147ff') */
/* 						$('#calendar').find('tr').eq(0).find('td').css('color','#eeeeee') */
						
/* 						$('#schedule').find('tr').find('td').css('background','#e1d3f5') */
/* 						$('#schedule').find('tr').eq(0).find('td').css('background','#9147ff') */
/* 						$('#schedule').find('tr').eq(0).find('td').css('color','#eeeeee') */
		
#calendar tr td{
	background:#e1d3f5;
}			
			
#calendar tr:first-child td{
background:#9147ff;
color:#eeeeee;
}			

#schedule tr td{
	background:#e1d3f5;
}			
			
#schedule tr:first-child td{
background:#9147ff;
color:#eeeeee;
}			
						

#z7
{
text-align:center;
margin-bottom: 13px;
font-size:20px;
}

.sec {
	float: left;
    width: 45%;
    height: 40%;
}

#search{
    width: 53px;
    height: 28px;
}

#calendar tr td {
	width: 50px;
	height: 50px;
	
    padding:2.3px;
    cursor:pointer;
    text-align: center;
}

#schedule tr td{

width:100px;
text-align:center;
}
#section_right
{
height: 500px;
    overflow: auto;
    margin-left: 10%;
    width: 35%;
}
.Btn {
	    width: 97px;
    height: 30px;
    border: none;
    background: #9147ffba;
    margin-right: 13px;
    color: #eeeeee;
    border-radius: 5px;
}

#calendar{
	    padding: 2.5px;
	    margin: 0 auto;
}

header{
    padding-top: 5%;
    text-align: center;
}

footer{
    text-align: center;
}

section{
    margin-top: 5%;
}

#section_left{
    margin-left: 5%;
}

.fcBlue{
color:#6498f7
}

.fcRed{
color:#f75573
}

</style>

<script type="text/javascript">


	//input[type="date"] 왼쪽의 값 담기위한 변수
	var start_year;
	var start_month;
	var start_day;

	//input[type="date"] 오른쪽의 값 담기위한 변수
	var end_year;
	var end_month;
	var end_day;

	//현재날짜월
	var current_month = 0
	var current_year = 0
	//국경일 담기위한
	var holiday = new Array();

	var SelctedCellNum = 0; //현재 클릭된 셀이 몇개인지, 몇번째가 먼저 눌린 셀인지
	var SelctedCell1 = ''; //클릭된셀 1 정보
	var SelctedCell2 = ''; // 클릭된 셀 2 정보
	var preSelectedEl1; //클릭된셀 1 엘리먼트
	var preSelectedEl2; //클릭된셀 2 엘리먼트
	//조회 클릭하였는지 확인하기위함
	var YN = false;

	//행 열 위치에 그려주는 function
	var setCell = function(id, row, cell, argVal) {
		$('#' + id).find('tr').eq(row).find('td').eq(cell).text(argVal)
	}
     
	//달력 그리기위한 함수
	var drawCalender = function(y, m, start_day, end_day) {
		var totDay = new Date(y, m, 0).getDate() //월의 일수
		var firstDay = new Date(y, m - 1, 1).getDay() // 월의 첫날 요일
		var thisCell, chk = 1;

		if (start_day == 0)
			start_day = 1;
		if (end_day == 0)
			end_day = totDay;

		for (var i = 1; i < 7; i++) {
			for (var j = 0; j < 7; j++) {
				setCell('calendar', i, j, '');
				thisCell = (i - 1) * 7 + j - firstDay + 1; //cell에 그려질지 안그려질지 계산 i 와 j를 이용 하였음 //배열처럼인지
				if (start_day <= thisCell && thisCell <= end_day) //시작날짜부터 끝날짜까지 그려줌
					setCell('calendar', i, j, thisCell);
			}
		}
	}//end drawCalender
	
   //달력위 년 월 표시하기위한 함수
	var setYD = function(current_y, current_m) {
		$("#c_year").text(current_y + "년");
		$("#c_month").text(current_m + "월")
	}
    //일자 요일 국경일 출력하기위한 함수
	var setSchedule = function(year, month, day, week, YesNo) {
		var crm = (month+"").length == 2 ? month : '0' + month;
		var dayClass =''
		if(week=="토요일")
			{
				dayClass = 'fcBlue'
			}
		else if(week=="일요일")
			{
				dayClass = 'fcRed'
			}
		
		
		
		var sch = "<tr class =" + dayClass +"><td>" + year + "-" + crm + "-" + day + "</td><td>"
				+ week + "</td><td>" + YesNo + "</td></td>"
				
				
				
		$('#schedule').append(sch);
	}
	
   //요일 출력하기위한 함수
	var day_week = function(day) {

		var res = '';
		switch (day) {
		case 0:
			res = "일요일";
			break;
		case 1:
			res = "월요일"
			break;
		case 2:
			res = "화요일"
			break;
		case 3:
			res = "수요일"
			break;
		case 4:
			res = "목요일"
			break;
		case 5:
			res = "금요일"
			break;
		case 6:
			res = "토요일"
			break;
		}
		return res;
	}
	var holi = function() {
		$.ajax({
			url : "/calendarexample/calendar/res?start_year=" + start_year
					+ "&start_month=" + start_month + "&end_year=" + end_year
					+ "&end_month=" + end_month,
			type : "get",
			dataType : "json",
			async : false,
			success : function(str) {
				for ( var i in str) {
					holiday.push(str[i]);
					console.log("공휴일은?" + str[i]);
				}				
			},
			error : function(request, status, error) {
				console.log(error);
			}

		});
	}
	$(document)
			.ready(
					function() {
						
// 						$('#calendar').find('tr').find('td').css('background','#e1d3f5')
// 						$('#calendar').find('tr').eq(0).find('td').css('background','#9147ff')
// 						$('#calendar').find('tr').eq(0).find('td').css('color','#eeeeee')
						
// 						$('#schedule').find('tr').find('td').css('background','#e1d3f5')
// 						$('#schedule').find('tr').eq(0).find('td').css('background','#9147ff')
// 						$('#schedule').find('tr').eq(0).find('td').css('color','#eeeeee')

						$('#apply').on('click',function() {
											if (YN == false) {
												alert("조회를 먼저 눌러주세요");
												return false;
											}
											holi();
											var sch_start;
											var sch_end;
											var YesNo = "아니오"
											//큰거 작은거 판단
											if (SelctedCell1*1 > SelctedCell2*1) {
												sch_start = SelctedCell2;
												sch_end = SelctedCell1;
											} else {
												sch_start = SelctedCell1;
												sch_end = SelctedCell2;
											}
											//흠여기가 문제인거같음
											var sch_start_year = sch_start.substr(0, 4)*1;
											var sch_start_month = sch_start.substr(4, 2)*1;
											var sch_start_day = sch_start.substr(6,sch_start.length - 6)*1;
											var sch_end_year = sch_end.substr(0, 4)*1;
											var sch_end_month = sch_end.substr(4, 2)*1;
											var sch_end_day = sch_end.substr(6,sch_end.length - 6)*1;
											
											/* var y,m,d,firstDay
											for(i=sch_start*1;i<=sch_end*1;i++){
												y = (i+'').substr(0,4);
												m = (i+'').substr(0,4);
												d = (i+'').substr(0,4);
												firstDay = new Date(y, m - 1,d).getDay() // 월의 첫날 요일set
												
												for (var z = 0; z < holiday.length; z++) {
													if (date_h == holiday[z]) {
														YesNo = "예";
													}
												}
												
												setSchedule(k,i,j,day_week(firstDay),YesNo);
											} */
													

											for (var k = sch_start_year; k <= sch_end_year; k++) {
												
												var month;
												if (k == sch_end_year) {
													month = sch_end_month;
												} else {
													month = 12;
												}
												
												for (var i = sch_start_month; i <= month; i++) {

													if (i == sch_end_month
															&& k == sch_end_year) {
														totDay = sch_end_day;
													} else {
														var totDay = new Date(k, i, 0).getDate() //월의 일수
													}
													
													for (var j = sch_start_day*1; j <= totDay*1; j++) {
													    
														var crm1 =(i+"").length ==2 ? i : '0'+j;
														var crm2 =(j+"").length ==2 ? j : '0'+j;
														
														var date_h = k + "" + crm1	+ "" + crm2;
														console.log(date_h)
														
														//여기 0붙고 안붙고 문제
														for (var z = 0; z < holiday.length; z++) {
															if (date_h == holiday[z]) {
																YesNo = "예";
															}
														}
														var firstDay = new Date(k, i - 1, j).getDay() // 월의 첫날 요일set
														setSchedule(k,i,j,day_week(firstDay),YesNo);
														YesNo = "아니요";
													}//for3

													sch_start_day = 1;

												}//for2
												sch_start_month = 1;

											}//for1

										})

						// 어떤 날짜 선택했는지 담기위한 클릭이벤트 function
						$('#calendar tr td')
								.on(
										'click',
										function() {
											
											if (current_month == 0)
												{
												alert('날짜를 먼저선택해주세요')
												return;
												}
											else if($(this).text()=="")
												{
												alert('빈칸을 선택하셨습니다.')
												return;
											}
											var crm = (current_month+'').length == 2 ? current_month
													: '0' + current_month;
											
											if ($(this).text() != SelctedCell1
													.substr(6, 2)
												&& $(this).text() != SelctedCell2
															.substr(6, 2)) {
												switch (SelctedCellNum) {
												case 0:
													SelctedCellNum++;
													//이게먼의미지
													if (preSelectedEl1)
														preSelectedEl1.css(
																'background',
																'#e1d3f5');
													SelctedCell1 = current_year+""
															+ crm+""
															+ $(this).text();
													$(this).css('background',
															'#d6afea');
													preSelectedEl1 = $(this);
													break;
												case 1:
													SelctedCellNum--;
													if (preSelectedEl2)
														preSelectedEl2.css(
																'background',
																'#e1d3f5');
													SelctedCell2 = current_year+""
															+ crm+""
															+ $(this).text();
													$(this).css('background',
															'#b586e0');
													preSelectedEl2 = $(this);
													break;
												}
											}

											console.log('선택1:' + SelctedCell1)
											console.log('선택2:' + SelctedCell2)

										})

						$('#btnNxt')
								.on(
										'click',
										function() {
											if (YN == false) {
												alert("조회를 먼저 눌러주세요");
												return false;
											}

											if (current_month != 12
													&& current_year == end_year) {
												if (current_month < end_month) {
													if (current_month + 1 == end_month)
														drawCalender(
																current_year,
																end_month, 0,
																end_day);
													else
														drawCalender(
																current_year,
																current_month + 1,
																0, 0);
												}

												else {
													console.log('끝')
													return;
												}

											}

											else {

												if (end_month == 1
														&& current_year == end_year) {
													drawCalender(current_year,
															end_month, 0,
															end_day);
												} else {
													drawCalender(current_year,
															current_month + 1,
															0, 0);
												}

											}//

											if (current_month == 12) {
												current_month = 1;
												current_year++;
											} else {
												current_month++;
											}//

											setYD(current_year, current_month);

										})

						$('#btnPre')
								.on(
										'click',
										function() {
											
											if (YN == false) {
												alert("조회를 먼저 눌러주세요");
												return false;
											}

									

											if (current_month != 1
													&& current_year == start_year) {
												if (current_month > start_month) {
													if (current_month - 1 == start_month)
														drawCalender(
																current_year,
																start_month,
																start_day, 0);
													else
														drawCalender(
																current_year,
																current_month - 1,
																0, 0);
												}

												else {
													console.log('끝')
													return;
												}

											}

											else {

												if (start_month == 12
														&& current_year == start_year) {
													drawCalender(current_year,
															start_month,
															start_day, 0);
												} else {
													drawCalender(
															current_year - 1,
															12, 0, 0);
												}
											}//

											if (current_month == 1) {
												current_month = 12;
												current_year--;
											} else {
												current_month--;
											}//

											setYD(current_year, current_month);
										})

						//조회 눌렀을시 이벤트실행
						$("#search")
								.on(
										"click",
										function() {
											//조회 눌렀을시 next prev 사용가능하게 하기위함
											YN=true;
											console.log("seach 클릭")
											//왼쪽 날짜 선택 값 입력
											var start_date = $("#start_date_c")
													.val().split('-'); //날짜
											var start_date_eq = (start_date[0]
													+ start_date[1] + start_date[2]) * 1;

											start_year = start_date[0] * 1; //year
											start_month = start_date[1] * 1; //month
											start_day = start_date[2] * 1; //day

											//오른쪽 날짜 선택 값 입력
											var end_date = $("#end_date_c")
													.val().split('-');
											var end_date_eq = (end_date[0]
													+ end_date[1] + end_date[2]) * 1
											end_year = end_date[0] * 1;
											end_month = end_date[1] * 1;
											end_day = end_date[2] * 1;

											if ($('#start_date_c').val() === ""
													|| $('#end_date_c').val() === "") {
												alert("날짜를 선택해주세요.");
												return false;
											} else if (start_date_eq > end_date_eq) {
												alert("날짜를 잘못 선택하셨습니다.")
												$('#start_date_c').val("");
												$('#end_date_c').val("");
												return false;
											}

											//현재 년 월
											current_month = start_month * 1
											current_year = start_year * 1

											if (start_year == end_year
													&& start_month == end_month)
												drawCalender(current_year,
														current_month,
														start_day, end_day);
											else
												drawCalender(current_year,
														current_month,
														start_day, 0);

											setYD(start_year, start_month);

										}); //end search

					})//end ready
</script>
</head>
<body>
	<header>
	
	<div>
				<span>기간</span> <input type="date" min="1900-01-01" max="3000-12-31"
					id="start_date_c"
				> ~ <input type="date" min="1900-01-01" max="3000-12-31"
					id="end_date_c"
				> <input type="button" value=" 조회" id="search"  class='Btn'/>
			</div>
	
	</header>
	<section>
	<div id = 'wrap'>
		<div id="section_left" class="sec">
			<div id="calendar_wrap">
				<div  id="z7">
					<span id="c_year">년</span><span id="c_month">월</span>
				</div>
				<div>
					<table id="calendar">
						<tr>
							<td>Sun</td>
							<td>Mon</td>
							<td>Tue</td>
							<td>Wed</td>
							<td>Thu</td>
							<td>Fri</td>
							<td>Sat</td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</table>
				</div>
				
			</div>

		</div>
		<div id="section_right" class="sec">
			<table id="schedule">
				<tr>
					<td>일자</td>
					<td>요일
					<td>국경일</td>
				</tr>
			</table>
		</div>
 </div>

	</section>
	<footer>
	
	<div>
					<button id='btnPre' class='Btn'>pre</button>
					<button id='btnNxt' class='Btn'>nex</button>
					<button class='Btn' id="apply" >apply</button>
					
				</div>
	</footer>

</body>
</html>