# List of tables you want to create connectors for
$tables = @("SampleTable", "Employees", "JobDetails")

# Kafka Connect REST API URL
$apiUrl = "http://localhost:8083/connectors"

# Loop over each table and create a configuration
foreach ($table in $tables) {
    $config = @{
        name = "source-connector-$table"
        config = @{
            "name" = "source-connector-$table"
            "connector.class" = "io.debezium.connector.sqlserver.SqlServerConnector"
            "database.hostname" = "host.docker.internal"
            "database.user" = "SA"
            "database.password" = "MyPassword123!"
            "database.names" = "KafkaDb"
            "topic.prefix" = "etl"
            "table.include.list" = "dbo.$table"
            "snapshot.mode" = "initial"
            "schema.history.internal.kafka.topic" = "dbHistory.dbo.$table"
            "schema.history.internal.kafka.bootstrap.servers" = "redpanda:29092"
            "value.converter" = "io.confluent.connect.avro.AvroConverter"
            "value.converter.schema.registry.url" = "http://redpanda:8081"
            "key.converter" = "io.confluent.connect.avro.AvroConverter"
            "key.converter.schema.registry.url" = "http://redpanda:8081"
            "time.precision.mode" = "connect"
            "database.encrypt" = "false"
            "event.metadata.source.connector.name" = "source-connector-$table"
            "event.metadata.source.connector.version" = "1.0"
            "event.metadata.field.addition" = "debezium.source.connector=source-connector-$table"
        }
    }

    # Convert the configuration to JSON
    $jsonConfig = $config | ConvertTo-Json -Depth 3

    # Send POST request to create the connector
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -ContentType "application/json" -Body $jsonConfig

    # Output the response
    Write-Output "Created connector for ${table}: $response"
}
