import boto3
from flask import Flask, jsonify, request
from boto3.dynamodb.conditions import Key

app = Flask(__name__)
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Reviews')

@app.route('/reviews', methods=['GET', 'POST'])
def reviews():
    if request.method == 'POST':
        content = request.json
        response = table.put_item(Item=content)
        return jsonify(response)
    else:
        response = table.scan()
        return jsonify(response['Items'])

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
