#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

// Core ImGui & JSON Translator
#include "imgui/imgui.h"
#include "imgui/imgui_impl_metal.h"
#include "imgui/json.hpp"

using json = nlohmann::json;

// --- State Variables ---
bool show_atlas = true;
int current_tab = 0; // 0: Executor, 1: Script Hub, 2: Settings
static char script_buffer[1024 * 32] = "-- Atlas Executor\nprint('Hello from Atlas!')";
static char search_query[128] = "";

// --- Arceus X / Delta Style Theme ---
void ApplyAtlasStyle() {
    ImGuiStyle& style = ImGui::GetStyle();
    style.WindowRounding = 8.0f;
    style.ChildRounding = 5.0f;
    style.FrameRounding = 5.0f;
    
    ImVec4* colors = style.Colors;
    colors[ImGuiCol_WindowBg] = ImVec4(0.07f, 0.07f, 0.09f, 0.95f);
    colors[ImGuiCol_ChildBg]  = ImVec4(0.09f, 0.09f, 0.12f, 1.00f);
    colors[ImGuiCol_Button]   = ImVec4(0.12f, 0.58f, 0.95f, 1.00f); // Signature Blue
    colors[ImGuiCol_Header]   = ImVec4(0.12f, 0.58f, 0.95f, 0.40f);
}

// --- Tab 1: Executor ---
void RenderExecutorTab() {
    ImGui::Text("Lua Editor");
    ImGui::InputTextMultiline("##Editor", script_buffer, IM_COUNTOF(script_buffer), ImVec2(-1, 220), ImGuiInputTextFlags_AllowTabInput);
    
    if (ImGui::Button("Execute", ImVec2(100, 35))) {
        // This is where you link your Lua VM (like Celeste or WeAreDevs API)
        printf("Atlas Executing: %s\n", script_buffer);
    }
    ImGui::SameLine();
    if (ImGui::Button("Clear", ImVec2(100, 35))) {
        memset(script_buffer, 0, sizeof(script_buffer));
    }
}

// --- Tab 2: Script Hub (ScriptBlox) ---
void RenderScriptHubTab() {
    ImGui::Text("ScriptBlox Search");
    ImGui::InputText
