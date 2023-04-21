project "GLAD"
	kind "StaticLib"
	language "C"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"include/glad/glad.h",
		"include/KHR/khrplatform.h",
		"src/glad.c"
	}

	includedirs
	{
		"include"
	}


	filter "system:windows"
		--systemversion "latest"
		systemversion "10.0.19041.0"

	filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"

	--filter { "system:windows", "configurations:Release" }
        --buildoptions "/MT"

	--filter { "system:windows", "configurations:Debug" }
		--buildoptions "/MT"


