# Kerberos
## _@Author : M3tr1c_r00t_

Kerberos is a network security protocol that authenticates service requests between trusted hosts across the internet(as it is considered unsecure). 

It uses secret-key cryptography and a trusted third party for authenticating client-server applications and verifying users' identities.

The protocol derives its name from the legendary three-headed dog Kerberos (also known as Cerberus) from Greek myths, the canine guardian to the entrance to the underworld. Kerberos had a snake tail and a particularly bad temper and, despite one notable exception, was a very useful guardian.

The three heads of the Kerberos protocol represent the following:
- the client or principal;
- the network resource, which is the application server that provides access to the network resource; and;
- a key distribution center (KDC), which acts as Kerberos' trusted third-party authentication service.

### How Kerberos works
Users, machines, and services that use Kerberos depend on the KDC alone, which works as a single process that provides two functions: authentication and ticket-granting. 
KDC "tickets" offer authentication to all parties, allowing nodes to verify their identity securely.

#### Traditional network protocols...
Before Kerberos, networked systems typically authenticated users with a user ID and password combination. The transmitted credentials were then transmitted over the unsafe and unsecure internet without any security/encryption. Therefore, attackers with access to the network could easily eavesdrop on network transmissions, intercept user credentials and then attempt to access systems.

To try and cater for this vulnerability, kerberos developers intended to provide system administrators a mechanism for authenticating access to systems over the internet.

 Kerberos is used in Posix authentication, and Active Directory, NFS, and Samba. It's also an alternative authentication system to SSH, POP, and SMTP.

#### Kerberos Authentication...
Whenever we send a request on a kerberos server;
The Client requests an authentication ticket (TGT) from the Key Distribution Center (KDC)
The KDC verifies the credentials and sends back an encrypted TGT and session key
The TGT is encrypted using the Ticket Granting Service (TGS) secret key
The client stores the TGT and when it expires the local session manager will request another TGT (this process is transparent to the user)
If the Client is requesting access to a service or other resource on the network, this is the process:

The client sends the current TGT to the TGS with the Service Principal Name (SPN) of the resource the client wants to access
The KDC verifies the TGT of the user and that the user has access to the service
TGS sends a valid session key for the service to the client
Client forwards the session key to the service to prove the user has access, and the service grants access.

#### Kerberos Auth....
How does the Kerberos authentication protocol work?
A simplified description of how Kerberos works follows; the actual process is more complicated and may vary from one implementation to another:

Authentication server request. To start the Kerberos client authentication process, the initiating client sends an authentication request to the Kerberos KDC authentication server. The initial authentication request is sent as plaintext because no sensitive information is included in the request. The authentication server verifies that the client is in the KDC database and retrieves the initiating client's private key.
Authentication server response. If the initiating client's username isn't found in the KDC database, the client cannot be authenticated, and the authentication process stops. Otherwise, the authentication server sends the client a TGT and a session key.
Service ticket request. Once authenticated by the authentication server, the client asks for a service ticket from the TGS. This request must be accompanied by the TGT sent by the KDC authentication server.
Service ticket response. If the TGS can authenticate the client, it sends credentials and a ticket to access the requested service. This transmission is encrypted with a session key specific to the user and service being accessed. This proof of identity is used to access the requested "Kerberized" service. That service validates the original request and then confirms its identity to the requesting system.
Application server request. The client sends a request to access the application server. This request includes the service ticket received in step 4. If the application server can authenticate this request, the client can access the server.
Application server response. In cases where the client requests the application server to authenticate itself, this response is required. The client has already authenticated itself, and the application server response includes Kerberos authentication of the server.
#### Hacking Kerberos
 Some of the more successful methods of hacking Kerberos include:

Pass-the-ticket: the process of forging a session key and presenting that forgery to the resource as credentials
Golden Ticket: A ticket that grants a user domain admin access
Silver Ticket: A forged ticket that grants access to a service
Credential stuffing/ Brute force: automated continued attempts to guess a password
Encryption downgrade with Skeleton Key Malware: A malware that can bypass Kerberos, but the attack must have Admin access
DCShadow attack: a new attack where attackers gain enough access inside a network to set up their own DC to use in further infiltration




### Sources...
```
https://www.varonis.com/blog/kerberos-authentication-explained
https://www.youtube.com/watch?v=5N242XcKAsM
https://www.techtarget.com/searchsecurity/definition/Kerberos

```
