package kr.or.chest.br.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

/**
 * 첨부파일 다운로드를 위한 전용 View class 이다.
 * 해당 view를 사용하기 위해서는 Controller 클래스내 메소드에서 view 클래스(FileDownloadView)를 리턴해야 한다.
 *
 * @author 김봉진
 * @version 1.0
 *
 * <pre>
 * 수정일 | 수정자 | 수정내용
 * ---------------------------------------------------------------------
 * 2016.11.15 김봉진 최초 작성
 * </pre>
 *
 */
public class FileDownloadView extends AbstractView {

    public FileDownloadView() {
        setContentType("applicaiton/download;charset=utf-8");
    }

    private void setDownloadFileName(String fileName, String realFileName, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(realFileName, "utf-8") + "\";");
        response.setHeader("Content-Transfer-Encoding", "binary");
    }

    private void downloadFile(File downloadFile, HttpServletRequest request, HttpServletResponse response) throws Exception {
        OutputStream out = response.getOutputStream();
        FileInputStream in = new FileInputStream(downloadFile);

        try {
            FileCopyUtils.copy(in, out);
            out.flush();
        } catch (Exception e) {
            throw e;
        } finally {
            try { if (in != null) in.close(); } catch (IOException ioe) {}
            try { if (out != null) out.close(); } catch (IOException ioe) {}
        }
    }

    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            File downloadFile = (File) model.get("downloadFile");
            String realFileNm = (String) model.get("realFileNm"); 
                        
            if (logger.isDebugEnabled()) {
                logger.debug("downloadFile: " + downloadFile);
            }

            this.setDownloadFileName(downloadFile.getName(),realFileNm, request, response);

            response.setContentLength((int) downloadFile.length());
            this.downloadFile(downloadFile, request, response);
        } catch (Exception e) {
            throw e;
        }
    }
}
