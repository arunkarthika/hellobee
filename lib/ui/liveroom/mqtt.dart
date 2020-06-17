import 'package:mqtt_client/mqtt_client.dart';

void publishMessage(String topic, String message, client) {
  print("inside");
  final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
  builder.addString(message);

  print('MQTTClientWrapper::Publishing message $message to topic $topic');
  client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
}
