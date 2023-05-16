package kr.or.chest.br.common;

import lombok.Data;

@Data
public class Paging {

	private int pageIndex; 			// 현재 페이지
    private int pageSize; 			// 페이지당 표시 행
    private int pageNumber;			// 페이지번호 수
    private int totalCount;			// 총 데이터 수
    private int startPage;			// 화면에 표시될 시작 페이지 번호
    private int endPage;			// 화면에 표시될 마지막 페이지 번호
    private int totalPage;			// 총 페이지 번호
    private boolean isPrev;			// 이전페이지 표시 여부
    private boolean isNext;			// 다음페이지 표시 여부
    private boolean isFirst;		// 첫 페이지이동 표시 여부
    private boolean isLast;			// 마지막 페이지이동 표시 여부

    public void initPaging() {
        this.pageIndex = 1;
        this.pageSize = 10;
        this.pageNumber = 10;
    }
    
    public void initPaging(int pageIndex) {
        this.pageIndex = pageIndex < 1 ? 1 : pageIndex;
        this.pageSize = 10;
        this.pageNumber = 10;
    }

    public void initPaging(int pageIndex, int pageSize) {
        this.pageIndex = pageIndex < 1 ? 1 : pageIndex;
        this.pageSize = pageSize;
        this.pageNumber = 10;
    }
    
    public void initPaging(int pageIndex, int pageSize, int pageNumber) {
        this.pageIndex = pageIndex < 1 ? 1 : pageIndex;
        this.pageSize = pageSize;
        this.pageNumber = pageNumber;
    }
    
    public void getPagination() {

    	// 마지막페이지 = (현재 페이지 번호 / 화면에 표시되는 페이지 번호의 갯수) * 화면에 표시되는 페이지 번호의 갯수
        endPage = (int) (Math.ceil(this.pageIndex / (double) this.pageNumber) * this.pageNumber);
        
        startPage = (this.endPage - this.pageNumber) + 1;
        if(startPage <= 0) {
        	startPage = 1;
        }
        
        totalPage = (int) (Math.ceil(this.totalCount / (double) this.pageSize));
        if (endPage > totalPage) {
            endPage = totalPage;
        }
 
        this.isPrev = this.startPage == 1 ? false : true;
        this.isNext = this.endPage * this.pageSize < this.totalCount ? true : false;
        
        this.isFirst = this.pageIndex <= 1 ? false : true;
        this.isLast = this.pageIndex == this.totalPage ? false : true;
    
    }
}
