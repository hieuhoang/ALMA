OUTPUT_DIR=${1:-"./mono/phi_3_small_8k_instruct"}
export HF_DATASETS_CACHE="/mnt/eastus/hieu/workspace/cache/huggingface/datasets"
export TRANSFORMERS_CACHE="/mnt/eastus/hieu/workspace/cache/huggingface/models/"
#export TRANSFORMERS_CACHE="/home/aiscuser/cache/huggingface/models/"

# random port between 30000 and 50000
port=$(( RANDOM % (50000 - 30000 + 1 ) + 30000 ))
accelerate launch --main_process_port ${port} --config_file configs/deepspeed_train_config.yaml \
     run_llmmt.py \
    --oscar_data_path oscar-corpus/OSCAR-2301 \
    --oscar_data_lang en,ru,cs,zh,is,de \
    --interleave_probs "0.17,0.22,0.14,0.19,0.08,0.2" \
    --streaming \
    --max_steps 600000 \
    --do_train \
    --low_cpu_mem_usage \
    --bf16 \
    --learning_rate 2e-6 \
    --weight_decay 0.01 \
    --gradient_accumulation_steps 4 \
    --lr_scheduler_type cosine \
    --warmup_ratio 0.01 \
    --ignore_pad_token_for_loss \
    --ignore_prompt_token_for_loss \
    --per_device_train_batch_size 4 \
    --per_device_eval_batch_size 4 \
    --save_strategy steps \
    --save_steps 3 \
    --save_total_limit 10 \
    --logging_strategy steps \
    --logging_steps 1 \
    --output_dir ${OUTPUT_DIR} \
    --max_new_tokens 256 \
    --max_source_length 256 \
    --seed 42 \
    --overwrite_output_dir \
    --report_to none \
    --model_name_or_path /mnt/eastus/hieu/workspace/experiment/llm/phi/download/phi_3_small_8k_instruct/
    #--model_name_or_path /mnt/eastus/hieu/workspace/experiment/llm/llama2/download/pth/Meta-Llama-3-8B-Instruct/hf
    #--model_name_or_path /mnt/eastus/hieu/workspace/experiment/llm/llama2/download/pth/Meta-Llama-3-8B/hf 
#    --model_name_or_path /mnt/eastus/hieu/workspace/experiment/llm/llama2/download/7b/model 


