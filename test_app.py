from app import app

def test_home():
    client = app.test_client()
    response = client.get('/')

    assert response.status_code == 200
    assert b"Hello aws engineer! CI/CD deployment is working successfully." in response.data
