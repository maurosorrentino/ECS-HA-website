import { render, screen, fireEvent } from "@testing-library/react";
import App from "./App";

// Mock fetch
beforeEach(() => {
  global.fetch = jest.fn(() =>
    Promise.resolve({
      json: () => Promise.resolve({ status: "success" }),
    })
  );
});

test("renders button and calls API", async () => {
  render(<App />);
  
  const button = screen.getByText(/Call API/i);
  expect(button).toBeInTheDocument();

  fireEvent.click(button);

  // Wait for the message to appear
  const message = await screen.findByText(/success/i);
  expect(message).toBeInTheDocument();
});
