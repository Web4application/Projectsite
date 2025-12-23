using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace LocalhostAuthExample
{
    // ========= MODELS =========

    record LoginRequest(
        string ClientId,
        string AuthToken,
        string Login,
        string? Password,
        string? PasswordHash,
        bool PassEncrypted
    );

    record LoginResponse(string Token);

    record ApiResponse<T>(T Data);

    record Product(int Id, string Name, decimal Price);

    // ========= PROGRAM =========

    class Program
    {
        // ---- CONFIG (localhost only) ----
        const string AUTH_BASE_URL = "http://localhost:8000";
        const string PRODUCTS_BASE_URL = "http://localhost:8080";

        const string CLIENT_ID = "aura";
        const string AUTH_TOKEN = "441be0dc4da0da9c3f196da62d72419883b75eb2023c0e5a6f202564a2f82234";
        const string LOGIN = "super";
        const string PASSWORD_HASH = "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8";

        static async Task Main()
        {
            Console.WriteLine("Starting localhost flow...\n");

            using var authClient = CreateClient(AUTH_BASE_URL);
            using var productsClient = CreateClient(PRODUCTS_BASE_URL);

            // 1️⃣ Login → get JWT
            var token = await LoginAsync(authClient);
            Console.WriteLine("JWT acquired\n");

            // 2️⃣ Use JWT → fetch products
            var products = await GetProductsAsync(productsClient, token);

            Console.WriteLine("Products:");
            Console.WriteLine(JsonSerializer.Serialize(
                products,
                new JsonSerializerOptions { WriteIndented = true }
            ));
        }

        // ========= HTTP CLIENT =========

        static HttpClient CreateClient(string baseUrl)
        {
            var client = new HttpClient
            {
                BaseAddress = new Uri(baseUrl),
                Timeout = TimeSpan.FromSeconds(10)
            };

            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/json"));

            return client;
        }

        // ========= AUTH =========

        static async Task<string> LoginAsync(HttpClient client)
        {
            var payload = new LoginRequest(
                CLIENT_ID,
                AUTH_TOKEN,
                LOGIN,
                null,
                PASSWORD_HASH,
                true
            );

            var response = await client.PostAsJsonAsync(
                "/_/security/login",
                payload
            );

            response.EnsureSuccessStatusCode();

            var login = await response.Content
                .ReadFromJsonAsync<LoginResponse>();

            if (login == null || string.IsNullOrWhiteSpace(login.Token))
                throw new Exception("Login failed: token missing");

            return login.Token;
        }

        // ========= PRODUCTS =========

        static async Task<List<Product>> GetProductsAsync(
            HttpClient client,
            string token)
        {
            client.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", token);

            var response = await client.GetAsync("/api/products");
            response.EnsureSuccessStatusCode();

            var payload = await response.Content
                .ReadFromJsonAsync<ApiResponse<List<Product>>>();

            return payload?.Data ?? new List<Product>();
        }
    }
}
