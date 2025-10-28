package com.example.calculator1

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.calculator1.ui.theme.Calculator1Theme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            Calculator1Theme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    CalculatorApp()
                }
            }
        }
    }
}

@Composable
fun CalculatorApp() {
    var displayText by remember { mutableStateOf("0") }
    var firstNumber by remember { mutableStateOf("") }
    var operator by remember { mutableStateOf("") }

    val buttons = listOf(
        listOf("7", "8", "9", "÷"),
        listOf("4", "5", "6", "×"),
        listOf("1", "2", "3", "-"),
        listOf("C", "0", "=", "+")
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF101010))
            .padding(12.dp),
        verticalArrangement = Arrangement.SpaceBetween
    ) {
        // Alphanumeric Display (8 chars max)
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
                .height(100.dp)
                .background(Color(0xFF1C1C1C)),
            contentAlignment = Alignment.CenterEnd
        ) {
            Text(
                text = displayText.padStart(8, ' '), // right align with padding
                color = Color(0xFF00FF66),
                fontSize = 48.sp,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.End,
                modifier = Modifier.padding(end = 20.dp)
            )
        }

        // Button Grid
        Column(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            for (row in buttons) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    for (symbol in row) {
                        CalculatorButton(
                            text = symbol,
                            modifier = Modifier
                                .weight(1f)
                                .aspectRatio(1f)
                        ) {
                            when (symbol) {
                                "C" -> {
                                    displayText = "0"
                                    firstNumber = ""
                                    operator = ""
                                }
                                "÷", "×", "-", "+" -> {
                                    if (displayText != "ERROR" && displayText != "OVERFLOW") {
                                        firstNumber = displayText
                                        operator = symbol
                                        displayText = ""
                                    }
                                }
                                "=" -> {
                                    val secondNumber = displayText
                                    val result = calculate(firstNumber, secondNumber, operator)
                                    displayText = result
                                    firstNumber = ""
                                    operator = ""
                                }
                                else -> {
                                    if (displayText.length < 8 && displayText != "ERROR" && displayText != "OVERFLOW") {
                                        displayText =
                                            if (displayText == "0") symbol else displayText + symbol
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// Calculation logic with overflow & error handling
fun calculate(num1: String, num2: String, operator: String): String {
    val n1 = num1.toDoubleOrNull() ?: return "ERROR"
    val n2 = num2.toDoubleOrNull() ?: return "ERROR"

    val result = when (operator) {
        "+" -> n1 + n2
        "-" -> n1 - n2
        "×" -> n1 * n2
        "÷" -> if (n2 == 0.0) return "ERROR" else n1 / n2
        else -> return "ERROR"
    }

    // Convert result to string and limit to 8 chars
    val resultStr = result.toString().take(8)

    return if (resultStr.length > 8 || result > 99999999 || result < -9999999)
        "OVERFLOW"
    else resultStr
}

// Button UI
@Composable
fun CalculatorButton(text: String, modifier: Modifier = Modifier, onClick: () -> Unit) {
    Box(
        contentAlignment = Alignment.Center,
        modifier = modifier
            .background(Color(0xFF333333))
            .clickable { onClick() }
            .padding(8.dp)
    ) {
        Text(
            text = text,
            fontSize = 28.sp,
            fontWeight = FontWeight.Bold,
            color = if (text in listOf("+", "-", "×", "÷", "=")) Color(0xFFFF9800) else Color.White
        )
    }
}
