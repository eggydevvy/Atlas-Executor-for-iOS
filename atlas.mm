#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#include "imgui/imgui.h"
#include "imgui/imgui_impl_metal.h"
#include "imgui/json.hpp" // For ScriptBlox API

using json = nlohmann::json;

// State Variables
bool show_atlas = true;
int current_tab = 0; // 0 = Executor, 1 = Script Hub
static char script_buffer[1024 * 16] = "";
static char search_query[128] = "";

void RenderExecutor() {
    ImGui::Text("Atlas Script Editor");
    ImGui::InputTextMultiline("##Editor", script_buffer, IM_COUNTOF(script_buffer), ImVec2(-1, 200));
    
    if (ImGui::Button("Execute", ImVec2(100, 30))) {
        // Logic to send script to the Lua VM goes here
    }
    ImGui::SameLine();
    if (ImGui::Button("Clear", ImVec2(100, 30))) {
        memset(script_buffer, 0, sizeof(script_buffer));
    }
}

void RenderScriptHub() {
    ImGui::Text("ScriptBlox Hub");
    ImGui::InputText("Search Scripts", search_query, IM_COUNTOF(search_query));
    
    if (ImGui::Button("Search on ScriptBlox")) {
        // In the final version, this triggers a network request
    }
    
    ImGui::Separator();
    ImGui::BeginChild("ResultsRegion");
    
    // Example Search Result (Delta Style)
    if (ImGui::Selectable("Infinite Yield (Universal)")) {
        strcpy(script_buffer, "loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()");
        current_tab = 0; // Switch back to editor
    }
    
    ImGui::EndChild();
}

void RenderAtlasMain(id<MTLRenderCommandEncoder> renderEncoder) {
    if (!show_atlas) return;

    ImGui_ImplMetal_NewFrame(renderEncoder);
    ImGui::NewFrame();

    // Main Window
    ImGui::SetNextWindowSize(ImVec2(550, 350), ImGuiCond_FirstUseEver);
    ImGui::Begin("Atlas Executor", &show_atlas, ImGuiWindowFlags_NoCollapse);

    // Sidebar Logic
    ImGui::BeginChild("Sidebar", ImVec2(120, 0), true);
    if (ImGui::Button("Executor", ImVec2(-1, 40))) current_tab = 0;
    if (ImGui::Button("Script Hub", ImVec2(-1, 40))) current_tab = 1;
    ImGui::EndChild();

    ImGui::SameLine();

    // Content Area
    ImGui::BeginGroup();
    if (current_tab == 0) RenderExecutor();
    else if (current_tab == 1) RenderScriptHub();
    ImGui::EndGroup();

    ImGui::End();
    ImGui::Render();
    ImGui_ImplMetal_RenderDrawData(ImGui::GetDrawData(), nil, renderEncoder);
}
