#include <videofilter.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/calib3d/calib3d.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgcodecs.hpp>
#include "opencv2/videoio.hpp"

using namespace cv;


QVideoFilterRunnable *VideoFilter::createFilterRunnable()
{
    return new FilterRunnable(this);
}

int VideoFilter::gaussianBlurSize() const
{
    return m_gaussianBlurSize;
}

void VideoFilter::setGaussianBlurSize(int gaussianBlurSize)
{
    m_gaussianBlurSize = gaussianBlurSize %2 == 1 ? gaussianBlurSize : m_gaussianBlurSize;
}

double VideoFilter::gaussianBlurCoef() const
{
    return m_gaussianBlurCoef;
}

void VideoFilter::setGaussianBlurCoef(double gaussianBlurCoef)
{
    m_gaussianBlurCoef = gaussianBlurCoef;
}

double VideoFilter::cannyThreshold() const
{
    return m_cannyThreshold;
}

void VideoFilter::setCannyThreshold(double cannyThreshold)
{
    m_cannyThreshold = cannyThreshold;
}

int VideoFilter::cannyKernelSize() const
{
    return m_cannyKernelSize;
}

void VideoFilter::setCannyKernelSize(int cannyKernelSize)
{

    m_cannyKernelSize = cannyKernelSize%2 == 1 ? cannyKernelSize : m_cannyKernelSize;
}


FilterRunnable::FilterRunnable(VideoFilter *filter) :
    m_filter(filter),
    m_gaussianBlurSize(7),
    m_gaussianBlurCoef(1.5),
    m_cannyThreshold(0),
    m_cannyKernelSize(3)

{
    m_filter->setGaussianBlurCoef(m_gaussianBlurCoef);
    m_filter->setGaussianBlurSize(m_gaussianBlurSize);
    m_filter->setCannyKernelSize(m_cannyKernelSize);
    m_filter->setCannyThreshold(m_cannyThreshold);
}

FilterRunnable::~FilterRunnable()
{

}

QVideoFrame FilterRunnable::run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, QVideoFilterRunnable::RunFlags flags)
{

    m_gaussianBlurSize = m_filter->gaussianBlurSize();
    m_gaussianBlurCoef = m_filter->gaussianBlurCoef();
    m_cannyKernelSize = m_filter->cannyKernelSize();
    m_cannyThreshold = m_filter->cannyThreshold();

    if (!input->isValid())
        return *input;

    input->map(QAbstractVideoBuffer::ReadWrite);

    this->deleteColorComponentFromYUV(input);

    cv::Mat mat(input->height(),input->width(), CV_8U, input->bits());
    cv::GaussianBlur(mat, mat, Size(m_gaussianBlurSize,m_gaussianBlurSize), m_gaussianBlurCoef, m_gaussianBlurCoef);
    cv::Canny(mat, mat, m_cannyThreshold, 3 * m_cannyThreshold, m_cannyKernelSize);

    input->unmap();
    return *input;

}

void FilterRunnable::deleteColorComponentFromYUV(QVideoFrame *input)
{
    // Assign 0 to Us and Vs
    int firstU = input->width()*input->height();
    int lastV = input->width()*input->height()+2*input->width()*input->height()/4;
    uchar* inputBits = input->bits();

    for (int i=firstU; i<lastV; i++)
        inputBits[i] = 127;
}
