use Device::I2C;
use Fcntl;
$dev = Device::I2C->new('/dev/i2c-1', O_RDWR);
$dev->checkDevice(0x54);

print $dev->readByteData(0x00) . "\n";
print $dev->readByteData(0xFC) . "\n";
print chr($dev->readByteData(0xFD)) . "\n";
print chr($dev->readByteData(0xFE)) . "\n";
print chr($dev->readByteData(0xFF)) . "\n";


print "current pos: " . $dev->readByteData(0x00) . "\n";
#$dev->writeByteData(0, 90);
