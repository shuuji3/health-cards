# FHIRで検証可能な医療情報

このドキュメントでは、[FHIR][fhir]でモデル化された医療情報を[W3C Verifiable Credentials][vc]（VC）基づいてどのように表現するのかを説明します。

## コンテンツの定義

検証可能な医療情報を提示したい場合には、まずはじめにユースケース特有の決定を行う必要があります。

1. 合わせてパッケージ化されて維持されなければならない、一連の必須およびオプションの**FHIR content resources**（例：`Immunization`や`Observation`など）を決める
2. これらのFHIR content resourcesを、**FHIR identity resources**（例：`Patient`）を経由して、個人の外部のIDと紐付ける方法を決める

これらを決定すれば、VCは、**credential subject**を使用して次のように構成できます。

* `credentialSubject`に以下のトップレベル要素を持たせる
    * `fhirVersion`: a string representation of the semantic FHIR version the content is represented in (e.g. `1.0.*` for DSTU2, `4.0.*` for R4, where `*` is a number, not a literal asterisk)
    * `fhirBundle`: a FHIR `Bundle` resource of type "collection" that includes all required FHIR resources (content + identity resources)

`"credentialSubject"`のpayloadは次のような結果になります。

```js
{
  "...",
  "fhirVersion": "4.0.1",
  "fhirBundle": {
    "resourceType": "Bundle",
    "type": "collection",
    "entry": [
      "..."
    ]
}
```

> 以下ではHealth Cardのユースケースにフォーカスしていますが、FHIRからVCを構築する同様のアプローチは他のユースケースにも適用できます。

## 「Health Card」をモデル化する

「Health Card」は、1つの独立したトピックに関する結果を伝達するVCです。この例では、ワクチン接種の詳細が記録された**COVID-19の免疫カード**です。他のカードとしては、たとえば、COVID-19のRT-PCRテストの詳細、COVID-19の診断結果、TDAPワクチンなどが考えられます。

上記のプロシージャにしたがって、まずはじめに、FHIR content resourcesとIDリソースについて決定を行います。

* どの**FHIR content resources**をパッケージに含める必要があるか？ 免疫（immunization）の例としては、次のことを考慮する必要があります。
    * 1回目の接種に関する詳細情報（製品情報、接種日、接種の実施者）を持った`Immunization`
    * 2回目の接種に関する詳細情報（製品情報、接種日、接種の実施者）を持った`Immunization`

* What **FHIR identity resources** do we need to bind the FHIR content resources to an external identity system? We might eventually define use-case-specific requirements, but we want to start with a recommended set of data elements for inclusion using the FHIR `Patient` resource. Resources MAY include an overall "level of assurance" indicating whether these demographic elements have been verified.

    * ベストプラクティス
        * 検証者（Verifiers）はIDデータを保存するべきではありません。そして、検証目的で必要なくなったらデータは直ちに削除するべきです。 
        * 検証者（Verifiers）はVC内のすべての要素が検証車の持つレコードに完全に一致することを期待するべきではありませんが、VC内に含まれる要素を使用することはできます。

## W3C VC Data Modelにマッピングする

SMART Health Card JWSからW3C Verifiable Credential [JSON-LD構文](https://www.w3.org/TR/vc-data-model/#json-ld)に一致する構造を作るために、次のことを行います。

1. JWS payloadの圧縮を解除する

2. `.vc`オブジェクトに追加する。

   ```
   "@context": [
     "https://www.w3.org/2018/credentials/v1",
     {
       "@vocab": "https://smarthealth.cards#",
       "fhirBundle": {
         "@id": "https://smarthealth.cards#fhirBundle",
         "@type": "@json"
       }
     }
   ]
   ```

3. `.vc.type`配列の最後に追加する: `"VerifiableCredential"`

4. [JWTのデコードルール](https://www.w3.org/TR/vc-data-model/#jwt-decoding)に従ってpayloadを処理する

### Health Cardの例

* [VC payloadの例](https://smarthealth.cards/examples/)

[vc]: https://w3c.github.io/vc-data-model/
[fhir]: https://hl7.org/fhir
