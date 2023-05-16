<%@ page session="true" buffer="none" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta  charset="utf-8"/>
</head>
<body>

	<div>나를클릭해봐</div>
	<div>나를클릭해봐</div>
	<div>나를클릭해봐</div>
	<div>나를클릭해봐</div>

	<script>
	
		// $.fn.extend() 는 $.fn 객체를 확장(extend) 하는데 사용된다.(플러그인 작성)
		// fn객체는 자바스크립트의 prototype객체를 의미한다.
		// JQuery 소스 코드를 열어보면 위와 같이 jQuery.fn 객체(Object)가 생성 되어 있다.
		// 아래 예제처럼 'myMethod()' 함수를 추가(확장)하여 메서드로 사용이 가능하다.

/*		$.fn.extend({
		    myMethod : function(){
		//alert("내가만든 메서드")
		$(this).css("background", "orange")
				        
		    }
		})

		또는 아래 형식처럼...*/
 		
 		$.fn.myMethod = function() {

 			//alert("내가만든 메서드")
 			$(this).css("background", "pink").text("내가 만든 메서드 실행");
			return this;  //메서드체인을 위해 this를 반환
 		};
        
		$("div").click(function(e) {

			$(this).myMethod();      // $(selecter).myMethod();
		});
		
//---------------------------------------------------------------------------------------
		
		// fn객체 없이 메서드 작성법 
		$.extend({
			myMethod2: function() {
			    
			    alert("hello")
			}
		});
		
		$.myMethod2();      // $.myMethod2();  // selecter없이 메서드 실행
		
	</script>
</body>
</html>
