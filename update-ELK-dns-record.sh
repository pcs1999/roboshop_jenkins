update-ELK-dns-record.shIP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=ELK"  --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

echo '
{
  "Comment": "CREATE/DELETE/UPSERT a record ",
  "Changes": [{
    "Action": "CREATE",
    "ResourceRecordSet": {
      "Name": "elk.chandupcs.online",
      "Type": "A",
      "TTL": 15,
      "ResourceRecords": [{ "Value": "IPADDRESS"}]
    }}]
}' | sed -e "s/IPADDRESS/${IP}/" >/tmp/ELK.json

ZONE_ID="Z04623222IZKOJZ0BZ3PB"
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/ELK.json | jq .