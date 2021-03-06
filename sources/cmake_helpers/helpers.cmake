macro(compute_config_py_values
      full_version_var_name
        )
    string(TIMESTAMP PACKAGE_BUILD_DATE "%Y-%m-%dT%H:%M:%S+00:00" UTC)
    if (PACKAGE_BUILD_DATE)
        set(PACKAGE_BUILD_DATE "__build_date__ = '${PACKAGE_BUILD_DATE}'")
    endif()

    if (PACKAGE_SETUP_PY_PACKAGE_VERSION)
        set(PACKAGE_SETUP_PY_PACKAGE_VERSION_ASSIGNMENT "__setup_py_package_version__ = '${PACKAGE_SETUP_PY_PACKAGE_VERSION}'")
        set(FINAL_PACKAGE_VERSION ${PACKAGE_SETUP_PY_PACKAGE_VERSION})
    else()
        set(FINAL_PACKAGE_VERSION ${${full_version_var_name}})
    endif()

    if (PACKAGE_SETUP_PY_PACKAGE_TIMESTAMP)
        set(PACKAGE_SETUP_PY_PACKAGE_TIMESTAMP_ASSIGNMENT "__setup_py_package_timestamp__ = '${PACKAGE_SETUP_PY_PACKAGE_TIMESTAMP}'")
    else()
        set(PACKAGE_SETUP_PY_PACKAGE_TIMESTAMP_ASSIGNMENT "")
    endif()

    find_package(Git)
    if(GIT_FOUND)
        # Check if current source folder is inside a git repo, so that commit information can be
        # queried.
        execute_process(
          COMMAND ${GIT_EXECUTABLE} rev-parse --git-dir
          OUTPUT_VARIABLE PACKAGE_SOURCE_IS_INSIDE_REPO
          ERROR_QUIET
          OUTPUT_STRIP_TRAILING_WHITESPACE)

        if(PACKAGE_SOURCE_IS_INSIDE_REPO)
            # Force git dates to be UTC-based.
            set(ENV{TZ} UTC)
            execute_process(
              COMMAND ${GIT_EXECUTABLE} --no-pager show --date=format-local:%Y-%m-%dT%H:%M:%S+00:00 -s --format=%cd HEAD
              OUTPUT_VARIABLE PACKAGE_BUILD_COMMIT_DATE
              OUTPUT_STRIP_TRAILING_WHITESPACE)
            if(PACKAGE_BUILD_COMMIT_DATE)
                set(PACKAGE_BUILD_COMMIT_DATE "__build_commit_date__ = '${PACKAGE_BUILD_COMMIT_DATE}'")
            endif()
            unset(ENV{TZ})

            execute_process(
              COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
              OUTPUT_VARIABLE PACKAGE_BUILD_COMMIT_HASH
              OUTPUT_STRIP_TRAILING_WHITESPACE)
            if(PACKAGE_BUILD_COMMIT_HASH)
                set(PACKAGE_BUILD_COMMIT_HASH "__build_commit_hash__ = '${PACKAGE_BUILD_COMMIT_HASH}'")
            endif()

            execute_process(
              COMMAND ${GIT_EXECUTABLE} describe HEAD
              OUTPUT_VARIABLE PACKAGE_BUILD_COMMIT_HASH_DESCRIBED
              OUTPUT_STRIP_TRAILING_WHITESPACE)
            if(PACKAGE_BUILD_COMMIT_HASH_DESCRIBED)
                set(PACKAGE_BUILD_COMMIT_HASH_DESCRIBED "__build_commit_hash_described__ = '${PACKAGE_BUILD_COMMIT_HASH_DESCRIBED}'")
            endif()

        endif()
    endif()

endmacro()

# Creates a new target called "${library_name}_generator" which
# depends on the mjb_rejected_classes.log file generated by shiboken.
# This target is added as a dependency to ${library_name} target.
# This file's timestamp informs cmake when the last generation was
# done, without force-updating the timestamps of the generated class
# cpp files.
# In practical terms this means that changing some injection code in
# an xml file that modifies only one specific class cpp file, will
# not force rebuilding all the cpp files, and thus allow for better
# incremental builds.
macro(create_generator_target library_name)
    add_custom_target(${library_name}_generator DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/mjb_rejected_classes.log")
    add_dependencies(${library_name} ${library_name}_generator)
endmacro()
