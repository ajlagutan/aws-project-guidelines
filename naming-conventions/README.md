# Naming Conventions
These following guidelines are for naming the solution and project files, when using __Visual Studio__ or __Visual Studio Code__ as a choice of IDE.

__What is Pascal Case?__ [^1] [^2]

When using pascal case, every word starts with an uppercase letter (in contrast to camel case, where the first word is in lowercase).

Here are some examples of how you would use pascal case:
```python
NumberOfDonuts = 34

FavePhrase = "Hello, world"
```

You will see the pascal case used for naming classes in most programming languages.

[^1]: [Snake Case VS Camel Case VS Pascal Case VS Kebab Case – What's the Difference Between Casings?](https://www.freecodecamp.org/news/snake-case-vs-camel-case-vs-pascal-case-vs-kebab-case-whats-the-difference/#pascal-case)

[^2]: [Programming Naming Conventions – Camel, Snake, Kebab, and Pascal Case Explained](https://www.freecodecamp.org/news/programming-naming-conventions-explained/#heading-what-is-pascal-case)

## Project Folder
The project folder name __must__ contain the service name.

#### Example:
| | |
|-|-|
| __Name__          | Card Issuer Service
| __Description__   | Handles all issuer and card bin related functions
| __Folder name__   | CardIssuerService

## Solution File
The solution (`.sln`) file name __must__ contain the service name. When using `cdk init` command line, the AWS CDK cli would use the [Project Folder](#project-folder) as the solution name.

#### Example:
| | |
|-|-|
| __Name__              | Merchant Account Service
| __Description__       | Handles all merchant related functions
| __Project folder__    | `MerchantAccountService`
| __Solution name__     | `MerchantAccountService.sln`

## Project File
The project file name __must__ contain the module name and the function it represents. When using `dotnet new` command line, by default, the _project file name_ is used as _root namespace_.

#### Example:
| | |
|-|-|
| __Name__          | Issuer: Create
| __Description__   | Handles the issuer creation function
| __Project file__  | `IssuerCreate.csproj`

## Namespace (Optional)
The root namespace __must__ contain the service, module, and project file name.

#### Example:
| | |
|-|-|
| __Service name__  | Card Issuer Service
| __Module name__   | Issuer
| __Function name__ | Issuer Create
```csharp 
namespace CardIssuerService.Issuer.IssuerCreate;
```
Or, using the abbreviated form of the _service name_:
```csharp
namespace CIS.Issuer.IssuerCreate;
```

> <br>
> <font color="goldenrod">
> <strong>WARNING‼</strong>
> </font>
> When changing the default <em>root namespace</em>, 
> the field <code>function-handler</code> of the <code>aws-lambda-tools-defaults.json</code> 
> file must be updated too.
> 
> <br>
> 
> Original configuration after `dotnet new`:
> ```json
> {
>   "Information": [
>       // omitted for brevity
>   ],
>   "profile": "",
>   "region": "",
>   "configuration": "Release",
>   "function-architecture": "x86_64",
>   "function-runtime": "dotnet8",
>   "function-memory-size": 512,
>   "function-timeout": 30,
>   "function-handler": "IssuerCreate::IssuerCreate.Function::FunctionHandler"
> }
> ```
> 
> Updated configuration after setting _custom namespace_:
> ```json
> {
>   // omitted for brevity
>   "function-handler": "IssuerCreate::CardIssuerService.Issuer.IssuerCreate.Function::FunctionHandler"
> }
> ```
> 
> > The JSON file is included in every project that has been initialized using 
> > `dotnet new lambda.EmptyFunction` command.
> 
> <br>
