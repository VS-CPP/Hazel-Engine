workspace "Hazel"														
	architecture "x64"													

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

include "Hazel/vendor/GLFW"
include "Hazel/vendor/Glad"


project "Hazel"															-- Aquvalent VS .vcxproj file
	location "Hazel"													-- project Folder
	kind "SharedLib"													-- project is DLL library
	language "C++"														 -- Set Program language

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")					 -- Output director for .exe files -- we create this output path here because output files make in Hazel Project
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")					-- Output director for .obj files -- we create this output path here because output files make in Hazel Project
	
    pchheader "hzpch.h"
    pchsource "Hazel/src/hzpch.cpp"                                    -- it is same: to go in VS open project setting and set pch file for create

	files
	{
		"%{prj.name}/src/**.h",											-- create all project files ** means that search all .h or .cpp files in src folder or it's subfolder'
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
        "%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",  							-- project Hazel include files for Compiler
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}"
	}

    links 
	{ 
		"GLFW",
        "Glad",
		"opengl32.lib",
        "Dwmapi.lib"
	}

    --For windows platform
	filter "system:windows"
        cppdialect "C++17"												-- Compiler definition
        staticruntime "On"												-- Linking Runtime library / I switch off it's not static any more'
        systemversion "latest"											-- windows SDK version

        -- #defines
        defines
        {
            "HZ_BUILD_DLL",
            "HZ_PLATFORM_WINDOWS",
            "GLFW_INCLUDE_NONE"                                         -- for not include OpenGL when include GLFW
        }


        postbuildcommands
        {
            -- Copy and Past the DLL file - Hazel.dll - from Hazel folder into Sandbox folder
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
        }

    filter "configurations:Debug"
		defines "HZ_DEBUG"
        buildoptions "/MDd"
		symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        buildoptions "/MD"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        buildoptions "/MD"
        optimize "On"


project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
        
        
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
        "Hazel/src"
    }


    -- Hazel project Linking to Sadnbox project
    links
    {
        "Hazel"
    }

    --For windows platform
    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"

        -- #defines
        defines
        {
            "HZ_PLATFORM_WINDOWS"
        }



    filter "configurations:Debug"
        defines "HZ_DEBUG"
        buildoptions "/MDd"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        buildoptions "/MD"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        buildoptions "/MD"
        optimize "On"