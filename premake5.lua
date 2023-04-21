workspace "Hazel"														
	architecture "x64"
    startproject "Sandbox"											

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}


outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"
IncludeDir["Glad"] = "Hazel/vendor/Glad/include"
IncludeDir["ImGui"] = "Hazel/vendor/Imgui"
IncludeDir["GLM"] = "Hazel/vendor/GLM"

--include "Hazel/vendor/GLFW"
--include "Hazel/vendor/Glad"
--include "Hazel/vendor/Imgui"

group "Dependenies"
    include "Hazel/vendor/GLFW"
    include "Hazel/vendor/Glad"
    include "Hazel/vendor/Imgui"

group ""


project "Hazel"															-- Aquvalent VS .vcxproj file
	location "Hazel"													-- project Folder
	--kind "SharedLib"													-- project is DLL library
    kind "StaticLib"                                                    -- project is Static library
	language "C++"														 -- Set Program language
    cppdialect "C++17"
    staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")					 -- Output director for .exe files -- we create this output path here because output files make in Hazel Project
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")					-- Output director for .obj files -- we create this output path here because output files make in Hazel Project
	
    pchheader "hzpch.h"
    pchsource "Hazel/src/hzpch.cpp"                                    -- it is same: to go in VS open project setting and set pch file for create

	files
	{
		"%{prj.name}/src/**.h",											-- create all project files ** means that search all .h or .cpp files in src folder or it's subfolder'
		"%{prj.name}/src/**.cpp",
        "%{prj.name}/vendor/GLM/glm/**.hpp",                            -- Include hpp files
        "%{prj.name}/vendor/GLM/glm/**.inl"
	}

    defines
	{
		"_CRT_SECURE_NO_WARNINGS"                                       -- this is for to Fix warnings: strcpy(), strcat() and sscanf() functions in imgui_impl_opengl3.cpp file
	}

	includedirs
	{
        "%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",  							-- project Hazel include files for Compiler
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}",
        "%{IncludeDir.GLM}"
	}


    links 
	{ 
		"GLFW",
        "Glad",
        "ImGui",
        "opengl32.lib"
        --"Dwmapi.lib"
	}

    --libdirs
    --{
       --"C:/ProgramFiles(x86)/Windows Kits/8.1/Lib/winv6.3/um/x64/opengl32.lib"
    --}

    --For windows platform
	filter "system:windows"
        --cppdialect "C++17"												-- Compiler definition
        --staticruntime "On"												-- Linking Runtime library / I switch off it's not static any more'
        --systemversion "latest"											-- windows SDK version
        systemversion "10.0.19041.0"                                        -- windows SDK version
        --links { "C:/Program Files (x86)/Windows Kits/10/Lib/10.0.19041.0/um/x64/OpenGL32.lib" }


        -- #defines
        defines
        {
            "HZ_BUILD_DLL",
            "HZ_PLATFORM_WINDOWS",
            "GLFW_INCLUDE_NONE"                                         -- for not include OpenGL when include GLFW
        }


        --postbuildcommands         // WE DONT NEED COPY/PASTE DLL ANY MORE, DONT USE DLL LIBRARY
        --{
            -- Copy and Past the DLL file - Hazel.dll - from Hazel folder into Sandbox folder
            --("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
        --}

    filter "configurations:Debug"
		defines "HZ_DEBUG"
        --buildoptions "/MTd"
        runtime "Debug"
		symbols "on"                      -- symbols means Debug config

    filter "configurations:Release"
        defines "HZ_RELEASE"
        --buildoptions "/MD"
        runtime "Release"
        optimize "on"                    -- optimize means without Debug = Release config

    filter "configurations:Dist"
        defines "HZ_DIST"
        --buildoptions "/MD"
        runtime "Release"
        optimize "on"


project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"
        
        
    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}") 
    
    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "Hazel/vendor/spdlog/include",
        "Hazel/src",
	    "Hazel/vendor",
        "%{IncludeDir.GLM}"
    }


    -- Hazel project Linking to Sadnbox project
    links
    {
        "Hazel"
    }

    --For windows platform
    filter "system:windows"
        staticruntime "On"
        --systemversion "latest"
        systemversion "10.0.19041.0"                                        -- windows SDK version
        --links { "C:/Program Files (x86)/Windows Kits/8.1/Lib/winv6.3/um/x64/opengl32.lib" }

        -- #defines
        defines
        {
            "HZ_PLATFORM_WINDOWS"
        }



    filter "configurations:Debug"
        defines "HZ_DEBUG"
        --buildoptions "/MTd"
        runtime "Debug"
        symbols "on"                       -- symbols means that this is a debug version

    filter "configurations:Release"
        defines "HZ_RELEASE"
        --buildoptions "/MD"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "HZ_DIST"
        --buildoptions "/MD"
        runtime "Release"
        optimize "on"