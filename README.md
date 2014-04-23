Perform OCR to a scanned book.

Do not give really accurate result.

Usage:

    make pdf2bmp PDF=/path/to/file.pdf
    make recognition (LANG=eng)
    make merge AUTHOR=author TITLE=title

Dependencies:

+ convert (ImageMagick)
+ pdftk
+ tesseract
+ hocr2pdf (ExactImage)

References from & thanks:

    http://blog.konradvoelkel.de/2013/03/scan-to-pdfa/
    http://blog.konradvoelkel.de/2010/01/linux-ocr-and-pdf-problem-solved/

MIT License
