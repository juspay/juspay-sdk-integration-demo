#———Sample Code For Handling Encrypted Response———
import json
import base64
from jwcrypto import jwk, jws, jwe

def load_pem_key(file_path):
    with open(file_path, "rb") as key_file:
        return jwk.JWK.from_pem(key_file.read())


def jwt_decrypt_request(body, private_key_path, public_key_path):
    # Load keys from PEM files
    private_key = load_pem_key(private_key_path)
    public_key = load_pem_key(public_key_path)

    # Deserialize the JWE response
    encrypted_jwe = jwe.JWE()
    encrypted_jwe.deserialize(
        json.dumps(
            {
                "protected": body["header"],
                "encrypted_key": body["encryptedKey"],
                "iv": body["iv"],
                "ciphertext": body["encryptedPayload"],
                "tag": body["tag"],
            }
        )
    )

    # Step 1: Decrypt the response payload using the Private Key
    encrypted_jwe.decrypt(private_key)
    decrypted_payload = encrypted_jwe.payload.decode("utf-8")

    # Deserialize the JWS response
    jws_body = json.loads(decrypted_payload)
    token = f"{jws_body['header']}.{jws_body['payload']}.{jws_body['signature']}"

    # Step 2: Verify the signature using the Public Key
    verified_jws = jws.JWS()
    verified_jws.deserialize(token)
    try:
        verified_jws.verify(public_key)
        return json.loads(verified_jws.payload)
    except Exception as e:
        raise ValueError(f"Signature verification failed: {str(e)}")


# Example usage
private_key_path = (
    "/Users/srikanthmitra/Downloads/MechantTEst/privateKey.pem" # Enter the actual path of Private key
)
public_key_path = "/Users/srikanthmitra/Downloads/MechantTEst/key_bd0bee7543a74435a8f4ce426c7cc234.pem" # Enter the actual path of Public key

response_body = {
    "encryptedKey": "C-NrIBWLE2dYXTpTHzd9zA_0CGFEusCwzyzClw3ldfh5-i-JVy23E-S5F3Y7XtJDA6Y8JYV8Kols4XNvkwXbJXRMNfR9Omr2xQ1LKtPNV3U9fC6y2pq4Sfe9yanc4ktda9JqO_NJXRSRMGwLKr79wsIsyfL-OmFEUlbVZYXWdUdTcKBrb9PrFMWpcDt3CHWIV8C7OZgyrZUgTjtvJbf5ov7ygdq89j_r4xt29xDG2dJi3H8UZgYrpENB5cz2T5R9u3Q4ln4WggB33rUbXKzx0bI2o0QoqiQTyhlNnnJzloJvFiak2pGeeMuFJzOEkCn07IWMPHk4nRl3mYbtTVGNUw",
    "tag": "Yms8H-Y70eHOH4q9bPh3XQ",
    "header": "eyJlbmMiOiJBMjU2R0NNIiwiaWF0IjoxNzUxNTIxNjkwLCJraWQiOiJrZXlfYmQwYmVlNzU0M2E3NDQzNWE4ZjRjZTQyNmM3Y2MyMzQiLCJhbGciOiJSU0EtT0FFUC0yNTYiLCJleHAiOm51bGx9",
    "encryptedPayload": "8hqzk4G7d9Wf-YPkFRQ852vL7TLP6UV_V7nkpfmAeYo6NOkLbIddTbh2rAvhJWlgHTkZizqwSjzzjxvKtQ6qBKl_feA6RoIlslfRezPT6rfwskbXVEEsS3dskfsZW3alOht7IYRZ5-l3T8lPH3J4IxjJPxF6ItSqufdRUdisbQTHiKoR-jQdABJN00vx6XWbre4JpKiY5bSyYlTrzSa37bx9nJcLp8qTrX_mXsg_M_AkCRkUIPbN8vUjtlJOcNTTGZfkI5oVUjLcrCUYPDSIXIYNBsjec3Dd50OXKelDUQJn92026-RM6Ud2t2v29mpZzMKbbSTHukT8UNmjp6HgF-Nzb2Lks4PBU6v1mtHtB1neC0DKdG-dXuJlzPof0FdnzdkbdMaAHgM59aZy1bJhHynEl_3I0YBPd3gAfkwOnku34aL6CZ3-CxtOhFUdcG8f9lHFk1L4ydCmNYFqDHMVYUbVV_lse-YPL4bXrMeQG75BTh9Ig04xQoHj3yHXqlxlDaEUbBtWUKF9UXSkWQcOKIBJ7M_A4u83U4dpHqBEhvzCdas1ZPZy1D6OFJsx0Z3ZWW3VsMIH5JPeJg1Ei8q3jj8LvW_GeUTPFxYdVhINLbhk-a_ih494zfKUlcI_n2eiwEWHqtQ6Vcta8anvn18LUaqYs1yzToZnnXLcxYPiMO_Gf5Ygd9nEklerWyLoaAyhwrVAKaZvEiAqxK5VrAQ1gcO90hHyZI5I1QJTOtkdnsKRjp4rKOJBXj7IzclqpBUmuMs_0cGkvnuVM-ivaLwKmGbjXtx2gmzirnL01U6aSMMkIbjoi6ukSEdpCrq3NP4RIxMDFx_49LSeOCH27mCMvxdyNiouPK4V8h9tGjyChOCOpqxIJVVpYU89vejRK7mdMre3MP8Yw7ww3dq3V_mpEI9MKFhJu7VwSNZ45a5WZt-QucNE5zGmF5pEPi_uFNYt2aXSwa43s3qCMNNGamQYMLsrb0MjgfytyOtLoOt8a1D1Gw8BqDVOdBOpocOBfHZYjh2d2ktMlOuEjAGnoEWgSAb-d8B4ZXZ1QfA7VwW0oX2rlanw_1DQQcs6IKcXS7yX0FHNW8oNFx2HbXdgtspo3QeXpt_2FCfAyku2STVa3_IsozE3OecHVOO1q9LkspezB1X7c6WZ32WdG85-XbzQ-506UeYOeji8UqrVymCv7FX1gC3c-Q14-8XpFNSZIyGuomBqTwFf_MOKkDr1gJDUHE1LZlHizJ1zgKecy_HwR-4TCRaBSV2k3v2u-5n_r5LQq0DRCdFxUOwJd2NcT2xPsyfRzLBtTszMQwRCn727BxdlB7N74dVNKONftSqvwqpT-ygzTdWGolSt_VpisALhIdhcMTBB-ObLRZluEYkWBs-yqJ99pD09pRXdiZHK13lcexzERJk5ls5ZpBcnTV8oKsy2sa2cbFkhaD2pmpcP4D47fMe-BstIqktF_ZxVVELQEjM3wdLVmSSK_mn-iGK_CHpUyhU3iyTOoV-sb_7U-Tx-rK5nOesL-hH2CG5oIbbvSVezhtsJp0rbxS3poZLnUqud0RTeKlGYeBGC4TVAi8tV-7P6aM1wEGOiWUBGJj8TrVwtsbZipm1y6c-3PiNd2aKtvfbPenkFJ2dJHncKZGcVgDw0wvH-ci0Mdx_HxCKIyNL_yeFT2vGLAG8Dz3VKFc2-xlAbBk-S0A8h76JPNiByMSEodhVvK1u1bf5ARlIJvA9ta7DWsfJs3aF32fti21DGgmJjleoO7VzsgPF0UfhQFFhzt7L834eWq9s9T3u562ArQyAsLHtrto0pz6gWhKz9pGH6PyDgQpIj0u0wu--4rCddaZgRExrITwvGwhpdFao9B6B99E7ZN_Nic-qZLkQvoEjzlz0-Ykcudm4Oub3IGCFF_MYuBoV2_PGEx883KbayGrWSYe2KGqKwUMcRZInPd0zEYst12Q2EfXrxt30teJzTAR0r2YWNBK0wYKWje0rCNRNatUGde5nOPIt-2oEP3KNUowDKEfHAiPMcBtmz5NXMVFrNiW-pVtelk-r4i8qI-LvvvONfyGH246C5g9H4Xix_D0QjBBHX1-5awT4gaf54uoc8CmY4UVhyqbqPIiLKHClaooBU6h50uT2tF10lZ25ACoM-H0wtx8J-GSxuHFoQkjBdUds6zKI1U1b9XXi9-NcQGHZ8e1ZRu3d-3JU0WdJBdp9_q8WvZm3kzfOLa_6kPuHUbetEWEhyzwJVQCcFB79rQvxonMttZT9GeJyrEbTBuCoIzc-yuo4BMQL_d2ols6A5cpaGgNwy9awZp5L6BidAl4BSv9rAdzynFdXGEUKXgS0r1ub5UOzW482Vtixpdi2Sc0m5Ik7Qi_e9UU9gVpZGkmxiho1e4w",
    "iv": "VIQwzaQMHfIfI_1X"
}


decrpyted_responses = jwt_decrypt_request(
    response_body, private_key_path, public_key_path
)
print("decrpyted_responses", decrpyted_responses)
