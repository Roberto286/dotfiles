#!/usr/bin/env fish
# Tide prompt config shared across machines. After `tide configure`, regenerate with:
# fish -c 'for v in (set --names --universal | string match "tide_*"); echo "set -U $v "(string escape -- $$v); end'
set -U tide_aws_bg_color normal
set -U tide_aws_color FF9900
set -U tide_aws_icon 
set -U tide_bun_bg_color normal
set -U tide_bun_color FBF0DF
set -U tide_bun_icon 󰳓
set -U tide_character_color 5FD700
set -U tide_character_color_failure FF0000
set -U tide_character_icon ❯
set -U tide_character_vi_icon_default ❮
set -U tide_character_vi_icon_replace ▶
set -U tide_character_vi_icon_visual V
set -U tide_cmd_duration_bg_color normal
set -U tide_cmd_duration_color 87875F
set -U tide_cmd_duration_decimals 0

set -U tide_cmd_duration_threshold 3000
set -U tide_context_always_display false
set -U tide_context_bg_color normal
set -U tide_context_color_default D7AF87
set -U tide_context_color_root D7AF00
set -U tide_context_color_ssh D7AF87
set -U tide_context_hostname_parts 1
set -U tide_crystal_bg_color normal
set -U tide_crystal_color FFFFFF
set -U tide_crystal_icon 
set -U tide_direnv_bg_color normal
set -U tide_direnv_bg_color_denied normal
set -U tide_direnv_color D7AF00
set -U tide_direnv_color_denied FF0000
set -U tide_direnv_icon ▼
set -U tide_distrobox_bg_color normal
set -U tide_distrobox_color FF00FF
set -U tide_distrobox_icon 󰆧
set -U tide_docker_bg_color normal
set -U tide_docker_color 2496ED
set -U tide_docker_default_contexts default set -U tide_docker_default_contexts colima
set -U tide_docker_icon 
set -U tide_elixir_bg_color normal
set -U tide_elixir_color 4E2A8E
set -U tide_elixir_icon 
set -U tide_gcloud_bg_color normal
set -U tide_gcloud_color 4285F4
set -U tide_gcloud_icon 󰊭
set -U tide_git_bg_color normal
set -U tide_git_bg_color_unstable normal
set -U tide_git_bg_color_urgent normal
set -U tide_git_color_branch 5FD700
set -U tide_git_color_conflicted FF0000
set -U tide_git_color_dirty D7AF00
set -U tide_git_color_operation FF0000
set -U tide_git_color_staged D7AF00
set -U tide_git_color_stash 5FD700
set -U tide_git_color_untracked 00AFFF
set -U tide_git_color_upstream 5FD700

set -U tide_git_truncation_length 24

set -U tide_go_bg_color normal
set -U tide_go_color 00ACD7
set -U tide_go_icon 
set -U tide_java_bg_color normal
set -U tide_java_color ED8B00
set -U tide_java_icon 
set -U tide_jobs_bg_color normal
set -U tide_jobs_color 5FAF00
set -U tide_jobs_icon 
set -U tide_jobs_number_threshold 1000
set -U tide_kubectl_bg_color normal
set -U tide_kubectl_color 326CE5
set -U tide_kubectl_icon 󱃾
set -U tide_left_prompt_frame_enabled false
set -U tide_left_prompt_items pwd set -U tide_left_prompt_items git set -U tide_left_prompt_items newline set -U tide_left_prompt_items character
set -U tide_left_prompt_prefix ''
set -U tide_left_prompt_separator_diff_color ' '
set -U tide_left_prompt_separator_same_color ' '
set -U tide_left_prompt_suffix ' '
set -U tide_nix_shell_bg_color normal
set -U tide_nix_shell_color 7EBAE4
set -U tide_nix_shell_icon 
set -U tide_node_bg_color normal
set -U tide_node_color 44883E
set -U tide_node_icon 
set -U tide_os_bg_color normal
set -U tide_os_color normal

set -U tide_php_bg_color normal
set -U tide_php_color 617CBE
set -U tide_php_icon 
set -U tide_private_mode_bg_color normal
set -U tide_private_mode_color FFFFFF
set -U tide_private_mode_icon 󰗹
set -U tide_prompt_add_newline_before true
set -U tide_prompt_color_frame_and_connection 6C6C6C
set -U tide_prompt_color_separator_same_color 949494
set -U tide_prompt_icon_connection ' '
set -U tide_prompt_min_cols 34
set -U tide_prompt_pad_items false
set -U tide_prompt_transient_enabled false
set -U tide_pulumi_bg_color normal
set -U tide_pulumi_color F7BF2A
set -U tide_pulumi_icon 
set -U tide_pwd_bg_color normal
set -U tide_pwd_color_anchors 00AFFF
set -U tide_pwd_color_dirs 0087AF
set -U tide_pwd_color_truncated_dirs 8787AF


set -U tide_pwd_icon_unwritable 
set -U tide_pwd_markers .bzr set -U tide_pwd_markers .citc set -U tide_pwd_markers .git set -U tide_pwd_markers .hg set -U tide_pwd_markers .node-version set -U tide_pwd_markers .python-version set -U tide_pwd_markers .ruby-version set -U tide_pwd_markers .shorten_folder_marker set -U tide_pwd_markers .svn set -U tide_pwd_markers .terraform set -U tide_pwd_markers bun.lockb set -U tide_pwd_markers Cargo.toml set -U tide_pwd_markers composer.json set -U tide_pwd_markers CVS set -U tide_pwd_markers go.mod set -U tide_pwd_markers package.json set -U tide_pwd_markers build.zig
set -U tide_python_bg_color normal
set -U tide_python_color 00AFAF
set -U tide_python_icon 󰌠
set -U tide_right_prompt_frame_enabled false
set -U tide_right_prompt_items status set -U tide_right_prompt_items cmd_duration set -U tide_right_prompt_items context set -U tide_right_prompt_items jobs set -U tide_right_prompt_items direnv set -U tide_right_prompt_items bun set -U tide_right_prompt_items node set -U tide_right_prompt_items python set -U tide_right_prompt_items rustc set -U tide_right_prompt_items java set -U tide_right_prompt_items php set -U tide_right_prompt_items pulumi set -U tide_right_prompt_items ruby set -U tide_right_prompt_items go set -U tide_right_prompt_items gcloud set -U tide_right_prompt_items kubectl set -U tide_right_prompt_items distrobox set -U tide_right_prompt_items toolbox set -U tide_right_prompt_items terraform set -U tide_right_prompt_items aws set -U tide_right_prompt_items nix_shell set -U tide_right_prompt_items crystal set -U tide_right_prompt_items elixir set -U tide_right_prompt_items zig
set -U tide_right_prompt_prefix ' '
set -U tide_right_prompt_separator_diff_color ' '
set -U tide_right_prompt_separator_same_color ' '
set -U tide_right_prompt_suffix ''
set -U tide_ruby_bg_color normal
set -U tide_ruby_color B31209
set -U tide_ruby_icon 
set -U tide_rustc_bg_color normal
set -U tide_rustc_color F74C00
set -U tide_rustc_icon 
set -U tide_shlvl_bg_color normal
set -U tide_shlvl_color d78700
set -U tide_shlvl_icon 
set -U tide_shlvl_threshold 1
set -U tide_status_bg_color normal
set -U tide_status_bg_color_failure normal
set -U tide_status_color 5FAF00
set -U tide_status_color_failure D70000
set -U tide_status_icon ✔
set -U tide_status_icon_failure ✘
set -U tide_terraform_bg_color normal
set -U tide_terraform_color 844FBA
set -U tide_terraform_icon 󱁢
set -U tide_time_bg_color normal
set -U tide_time_color 5F8787
set -U tide_time_format '%T'
set -U tide_toolbox_bg_color normal
set -U tide_toolbox_color 613583
set -U tide_toolbox_icon 
set -U tide_vi_mode_bg_color_default normal
set -U tide_vi_mode_bg_color_insert normal
set -U tide_vi_mode_bg_color_replace normal
set -U tide_vi_mode_bg_color_visual normal
set -U tide_vi_mode_color_default 949494
set -U tide_vi_mode_color_insert 87AFAF
set -U tide_vi_mode_color_replace 87AF87
set -U tide_vi_mode_color_visual FF8700
set -U tide_vi_mode_icon_default D
set -U tide_vi_mode_icon_insert I
set -U tide_vi_mode_icon_replace R
set -U tide_vi_mode_icon_visual V
set -U tide_zig_bg_color normal
set -U tide_zig_color F7A41D
set -U tide_zig_icon 
