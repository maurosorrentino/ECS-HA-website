## kms_policy.json Documentation

This file defines the IAM policy for Google Cloud KMS resources.  
You can edit `kms_policy.json` to allow specific roles and permissions for users, groups, or service accounts.  
Since JSON does not support comments, please refer to this README for guidance.

- **Roles**: Assign roles such as `roles/cloudkms.cryptoKeyEncrypterDecrypter` to grant encryption/decryption permissions.
- **Permissions**: Fine-tune access by specifying permissions like `cloudkms.cryptoKeyVersions.useToEncrypt` or `cloudkms.cryptoKeyVersions.useToDecrypt`.
- **Principals**: Use the `members` field to specify who receives the permissions (e.g., user emails, service accounts).

**Example Usage**:  
To allow a user to encrypt and decrypt data, add their email under the appropriate role in the `bindings` array.

**Note**:  
Always review and restrict permissions to follow the principle of least privilege.
