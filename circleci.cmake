
# set_from_env
# ------------
#
# Sets a CMake variable from an environment variable. If the
# environment variable  is not  defined then the CMake variable is not
# modified. If DEFAULT is specified then if the environment variable
# is not defined the default value is used. Alternatively, if REQUIRED
# is specified then a FATAL_ERROR is generated.
#
# set_from_env( <variable> <environment variable> [REQUIRED|DEFAULT value] )
function(set_from_env var env_var)
  if(NOT DEFINED ENV{${env_var}})
    if (ARGV2 STREQUAL "REQUIRED")
      message(FATAL_ERROR "Required environment variable \"${env_var}\" not defined.")
    elseif (ARGV2 STREQUAL "DEFAULT")
      set(${var} ${ARGV3} PARENT_SCOPE)
    endif()
  else()
    set(${var} $ENV{${env_var}} PARENT_SCOPE)
  endif()
endfunction()

set(CTEST_SITE "CircleCI")
set(CTEST_UPDATE_VERSION_ONLY 1)
set( CTEST_TEST_ARGS ${CTEST_TEST_ARGS} PARALLEL_LEVEL 2 )


# Make environment variables to CMake variables for CTest
set_from_env(CTEST_CMAKE_GENERATOR "CTEST_CMAKE_GENERATOR" DEFAULT "Unix Makefiles" )
set_from_env(CTEST_BINARY_DIRECTORY "CTEST_BINARY_DIRECTORY")
set_from_env(CTEST_DASHBOARD_ROOT  "CTEST_DASHBOARD_ROOT" REQUIRED)
set_from_env(CTEST_SOURCE_DIRECTORY "CTEST_SOURCE_DIRECTORY" REQUIRED)
set_from_env(CTEST_CONFIGURATION_TYPE "CTEST_CONFIGURATION_TYPE" DEFAULT "Release")

# Legacy support for MAKEJ environment variable
# Please set CTEST_BUILD_FLAGS directly
set_from_env(makej "MAKEJ")
set_from_env(CTEST_BUILD_FLAGS "CTEST_BUILD_FLAGS" DEFAULT ${MAKEJ})

# Construct build name based on what is being built
string(SUBSTRING $ENV{CIRCLE_SHA1} 0 7 commit_sha1)
set(CTEST_BUILD_NAME "CircleCI-$ENV{CIRCLE_BRANCH}-${commit_sha1}")

set_from_env(dashboard_git_branch "CIRCLE_BRANCH")
set_from_env(dashboard_model "DASHBOARD_MODEL" DEFAULT "Continuous" )
set(dashboard_loop 0)

list(APPEND CTEST_NOTES_FILES
  "${CTEST_SOURCE_DIRECTORY}/circleci.yml"
  )

SET (dashboard_cache "
    BUILD_DOCUMENTATION:BOOL=OFF
    BUILD_EXAMPLES:BOOL=OFF
    BUILD_SHARED_LIBS:BOOL=ON
    BUILD_TESTING:BOOL=ON
    ITK_USE_KWSTYLE:BOOL=OFF
    ITK_BUILD_DEFAULT_MODULES:BOOL=ON
    CMAKE_CXX_COMPILER_LAUNCHER:STRING=distcc
    CMAKE_C_COMPILER_LAUNCHER:STRING=distcc
" )


include("${CTEST_SCRIPT_DIRECTORY}/itk_common.cmake")

# itk_common produces a fatal error ( and exits ) if there is a build
# error or warning and also for test failures. If itk_common does not
# terminate execution of this script early, then the build is OK.
return(0)
