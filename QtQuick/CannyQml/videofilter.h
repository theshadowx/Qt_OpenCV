#ifndef VIDEOFILTER
#define VIDEOFILTER

#include <QAbstractVideoFilter>

class VideoFilter : public QAbstractVideoFilter
{
    Q_OBJECT

    Q_PROPERTY(int gaussianBlurSize READ gaussianBlurSize WRITE setGaussianBlurSize NOTIFY gaussianBlurSizeChanged)
    Q_PROPERTY(double gaussianBlurCoef READ gaussianBlurCoef WRITE setGaussianBlurCoef  NOTIFY gaussianBlurCoefChanged)
    Q_PROPERTY(int cannyKernelSize READ cannyKernelSize WRITE setCannyKernelSize NOTIFY cannyKernelSizeChanged)
    Q_PROPERTY(double cannyThreshold READ cannyThreshold WRITE setCannyThreshold  NOTIFY cannyThresholdChanged)


public:
    QVideoFilterRunnable *createFilterRunnable() Q_DECL_OVERRIDE;


    int gaussianBlurSize() const;
    void setGaussianBlurSize(int gaussianBlurSize);

    double gaussianBlurCoef() const;
    void setGaussianBlurCoef(double gaussianBlurCoef);

    double cannyThreshold() const;
    void setCannyThreshold(double cannyThreshold);

    int cannyKernelSize() const;
    void setCannyKernelSize(int cannyKernelSize);

private:
    int m_gaussianBlurSize;
    double m_gaussianBlurCoef;

    int m_cannyKernelSize;
    double m_cannyThreshold;

signals:
    void gaussianBlurSizeChanged();
    void gaussianBlurCoefChanged();
    void cannyKernelSizeChanged();
    void cannyThresholdChanged();
};



class FilterRunnable : public QVideoFilterRunnable
{

public:
    FilterRunnable(VideoFilter *filter);
    ~FilterRunnable();

    QVideoFrame run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags) Q_DECL_OVERRIDE;

private:
    VideoFilter *m_filter;

    void deleteColorComponentFromYUV(QVideoFrame *input);
};

#endif // VIDEOFILTER

