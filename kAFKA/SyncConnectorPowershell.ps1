# List of tables you want to create connectors for
$tables = @("SampleTable", "Employees", "JobDetails")

# Kafka Connect REST API URL
$apiUrl = "http://localhost:8083/connectors"

# Loop over each table and create a configuration
foreach ($table in $tables) {
    $config = @{
        name = "sink-connector-$table"
        config = @{
            "name" = "sink-connector-$table"
            "connector.class" = "io.confluent.connect.jdbc.JdbcSinkConnector"
            "connection.url" = "jdbc:sqlserver://host.docker.internal;databaseName=KafkaDbDestination"
            "connection.user" = "SA"
            "connection.password" = "MyPassword123!"
            "insert.mode" = "upsert"
            "pk.fields" = "ID"
            "pk.mode" = "record_value"
            "topics" = "etl.KafkaDb.dbo.$table"
            "table.name.format" = "${table}Dest"
            "auto.create" = "true"
            "value.converter" = "io.confluent.connect.avro.AvroConverter"
            "value.converter.schema.registry.url" = "http://redpanda:8081"
            "key.converter" = "io.confluent.connect.avro.AvroConverter"
            "key.converter.schema.registry.url" = "http://redpanda:8081"

            "transforms" = "unwrap,filter"
            "transforms.unwrap.type" = "io.debezium.transforms.ExtractNewRecordState"
            "transforms.unwrap.drop.tombstones" = "false"
            "transforms.unwrap.delete.handling.mode" = "none"
            "delete.enabled" = "true"
        }
    }

    # Convert the configuration to JSON
    $jsonConfig = $config | ConvertTo-Json -Depth 3

    # Send POST request to create the connector
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -ContentType "application/json" -Body $jsonConfig

    # Output the response
    Write-Output "Created connector for ${table}: $response"
}
