package project.shopping.servlet.captcha;

import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.octo.captcha.service.CaptchaServiceException;
import com.octo.captcha.service.image.ImageCaptchaService;

/**
 * 提供验证码图片的Servlet
 */
@SuppressWarnings("serial")
public class JcaptchaServlet extends HttpServlet {
	public static final String CAPTCHA_IMAGE_FORMAT = "jpeg";

	private ImageCaptchaService captchaService;

	@Override
	public void init() throws ServletException {
		super.init();
		WebApplicationContext appCtx = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext());
		captchaService = (ImageCaptchaService) appCtx.getBean("captchaService");

	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		byte[] captchaChallengeAsJpeg = null;
		ByteArrayOutputStream jpegOutputStream = new ByteArrayOutputStream();
		try {

			String captchaId = request.getSession().getId();
			// 放入session中
			BufferedImage challenge = captchaService.getImageChallengeForID(captchaId, request.getLocale());
			ImageIO.write(challenge, CAPTCHA_IMAGE_FORMAT, jpegOutputStream);
		} catch (IllegalArgumentException e) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		} catch (CaptchaServiceException e) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			return;
		}

		captchaChallengeAsJpeg = jpegOutputStream.toByteArray();

		// flush it in the response
		response.setHeader("Cache-Control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("image/" + CAPTCHA_IMAGE_FORMAT);

		ServletOutputStream responseOutputStream = response.getOutputStream();
		responseOutputStream.write(captchaChallengeAsJpeg);
		responseOutputStream.flush();
		responseOutputStream.close();
	}
}
