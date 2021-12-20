# QRコードに関するFAQ

### さまざまなエラー訂正レベルでのV22 QRに必要なJWSの最大長

A single, non-chunked Version 22 SMART Health Card QR contains two segments
* The first Byte mode segment (`shc:/`) always has 20 header bits and 40 data bits for a total of 60 bits.[<sup>1</sup>](https://www.nayuki.io/page/optimal-text-segmentation-for-qr-codes)
* The second segment (the numeric encoded QR code) always has 16 header bits and a variable number of data bits depending on the QR code length.[<sup>1</sup>](https://www.nayuki.io/page/optimal-text-segmentation-for-qr-codes)

The max JWS size that can fit in a single Version 22 QR code depends on the remaining space, which depends on the error correction used.

76 bits are already reserved for the required segment headers and `shc:/` prefix. The following table lists the total number of bits a Version 22 QR Code can contain.


| エラー訂正レベル | V22 QRの合計データビット |
| ------------- | ------------- |
| Low  | 8048  |
| Medium  | 6256  |
| Quartile  | 4544  |
| High  | 3536  |

[<sup>2 (Table Source)</sup>](https://www.qrcode.com/en/about/version.html)


[Encoding Chunks as QR codes](https://shuuji3.xyz/smart-health-cards-framefork/#encoding-chunks-as-qr-codes)に記述されているように、JWSの各文字は2文字の数字にエンコードされます。そして、各数字は20/6ビットを必要とします。[<sup>1</sup>](https://www.nayuki.io/page/optimal-text-segmentation-for-qr-codes)

したがって、それぞれのエラー訂正ごとのJWSの最大サイズを次のように決定できます。

JWSのサイズ
=  ((データの合計ビット数 - 76 bits reserved) * 6/20 bits per 数字1文字 * 1/2 JWS 文字 per 数字1文字
= (データの合計ビット数 - 76)*3/20

上記の結果を最も近い整数に切り捨てた文字数は、次のように与えられます。

| エラー訂正レベル | V22 QRに必要なJWSの最大長 |
| ------------- | ------------- |
| Low  | 1195  |
| Medium  | 927  |
| Quartile  | 670  |
| High  | 519  |

**リファレンス:**
1. [Project Nayuki: Optimal text segmentation for QR Codes](https://www.nayuki.io/page/optimal-text-segmentation-for-qr-codes)
2. [QR Code capacities](https://www.qrcode.com/en/about/version.html)
