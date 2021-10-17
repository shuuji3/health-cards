> このページは、[SMART Health Cards Framework](https://spec.smarthealth.cards/)の日本語翻訳です。SMART Health Cardsの仕様を日本語で理解する助けとなることを目的に提供しているものです。最新の情報については、オリジナルのウェブサイトを参照してください。

# FHIRで検証可能な医療情報

このドキュメントでは、[FHIR][fhir]でモデル化された医療情報を[W3C Verifiable Credentials][vc]（VC）基づいてどのように表現するのかを説明します。

## コンテンツの定義

検証可能な医療情報を提示したい場合には、まずはじめにユースケース特有の決定を行う必要があります。

1. 合わせてパッケージ化されて維持されなければならない、一連の必須およびオプションの**FHIR content resources**（例：`Immunization`や`Observation`など）を決める
2. これらのFHIR content resourcesを、**FHIR identity resources**（例：`Patient`）を経由して、個人の外部のIDと紐付ける方法を決める

これらの決定を行えば、**credential subject**を使用してVCを次のように構成できます。

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

* Which **FHIR content resources** need to be conveyed in a package? For the immunization example, we'd need:
    * `Immunization` with details about a first dose (product, date of administration, and administering provider)
    * `Immunization` with details about a second dose (product, date of administration, and administering provider)

* What **FHIR identity resources** do we need to bind the FHIR content resources to an external identity system? We might eventually define use-case-specific requirements, but we want to start with a recommended set of data elements for inclusion using the FHIR `Patient` resource. Resources MAY include an overall "level of assurance" indicating whether these demographic elements have been verified.

    * ベストプラクティス
        * Verifiers should not store identity data conveyed via VC, and should delete data as soon as they are no longer needed for verification purposes
        * Verifiers should not expect all elements in the VC to exactly match their own records, but can still use elements conveyed in the VC.

## W3C VC Data Modelにマッピングする

SMART Health Card JWSからW3C Verifiable Credential [JSON-LD Syntax](https://www.w3.org/TR/vc-data-model/#json-ld)に一致する構造を作るために、次のことを行います。

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

4. [JWT Decoding Rules](https://www.w3.org/TR/vc-data-model/#jwt-decoding)に従ってpayloadを処理する

### Health Cardの例

* [Example VC payloads](https://smarthealth.cards/examples/)

[vc]: https://w3c.github.io/vc-data-model/
[fhir]: https://hl7.org/fhir
