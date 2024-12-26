#!/bin/bash

# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

track=$1  # track1 or track2

output_dir="./commonvoice"
mkdir -p "${output_dir}"


langs=("de" "en" "es" "fr" "zh-CN")
# Please fill in URLs
# german, english, spanish, french, and chinese (china)
URLs=(
    "https://storage.googleapis.com/common-voice-prod-prod-datasets/cv-corpus-19.0-2024-09-13/cv-corpus-19.0-2024-09-13-de.tar.gz?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gke-prod%40moz-fx-common-voice-prod.iam.gserviceaccount.com%2F20241226%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20241226T010938Z&X-Goog-Expires=43200&X-Goog-SignedHeaders=host&X-Goog-Signature=70e67fca35819fe50179a9e216eab47f11ba11517a7d1df2f83094faa10877715275a5711e11826bf62c57f22ae7e5b546a145a15b0733e192a5334234f17a195f14c90a2eb35434a6d1bb9592a102fc7b5beff01179ce98f147589506fefd4e26efb33d86a1d8af580f21bdb5cb5dfd0f01352fa07d1bb335897d327ccf328d71626527ff68be5b388f758da0dee627f85dc1ed5bf0752ec527f81b36db0bb163208533f6da47054007c9349c9344d9dca6deb3733e536f985085ef1defc4b967281a201a129d0dd0e4340834f1f568d93b0ff1fd13d54cfaea55b7a57a58724459b97c0159b1e101d804d30e0aa763fc73151ad50385506684fbd378ea035c"
    "https://storage.googleapis.com/common-voice-prod-prod-datasets/cv-corpus-19.0-2024-09-13/cv-corpus-19.0-2024-09-13-en.tar.gz?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gke-prod%40moz-fx-common-voice-prod.iam.gserviceaccount.com%2F20241226%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20241226T010657Z&X-Goog-Expires=43200&X-Goog-SignedHeaders=host&X-Goog-Signature=ba0dba8025196fefbd715a8e0bdc9757d733df7d9a5d6f1a44c8032a736357d885077cf081ded9f9bbc06deda629856146cedc3fc0cb47a5ad3f477e6aaaa2cfa66767e0829de78b50cd9fdb9e4f02eb824ce2b8a8567769ef256307f87d4c24409bb01e80f737ea79b9a7c1eda3e36e8b2c07b91d31b74e2116825cfe398be915abceab7fa1bfe95c7568ec9016251f421d799b8c7d0b5b92ce571a1badff65c4f32f1861b00256230bb1cca6d37aadb168a6a8d8168519087bd9ed071f9336ddc098508b4006c433749e0c73d69278c79732a7f7e7027c249c68c817533c635abebbf0eed5fdaa0509a3f315dfdad96b640ebf0714daf3c0a8bd43e86aa253"
    "https://storage.googleapis.com/common-voice-prod-prod-datasets/cv-corpus-19.0-2024-09-13/cv-corpus-19.0-2024-09-13-es.tar.gz?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gke-prod%40moz-fx-common-voice-prod.iam.gserviceaccount.com%2F20241226%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20241226T011020Z&X-Goog-Expires=43200&X-Goog-SignedHeaders=host&X-Goog-Signature=7026f47fb556351f967275bed3898707acc21349694a587b463861a9558444d9b2fd2a7754850e62454482cbc072bcb7a1201134b8ecbb5888b58c0757bfb399dea1215444f8acb15c707d3c276fdfe13d57c4eeadf27ac63196b544ea772981e0d13708ddc616cfb112adcde9d47e11c961ebb01eb08f11202bf7c78e458204df96f2ff2c60087f9897f3c92f9c5a801592bc66a9c8aa0deeed03079053020d1fb4854269edba5391ee0c0c07452a04a5a30d83ac011a0b42cb5e0a8c7607d017e3f1184430833e986b12f690cee47681b4bdd7f21a676e2f79b000632c662220929880ae607e2dbd688cf8d7c76b9c8f7dbd877438f138f980812a802cac49"
    "https://storage.googleapis.com/common-voice-prod-prod-datasets/cv-corpus-19.0-2024-09-13/cv-corpus-19.0-2024-09-13-fr.tar.gz?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gke-prod%40moz-fx-common-voice-prod.iam.gserviceaccount.com%2F20241226%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20241226T011054Z&X-Goog-Expires=43200&X-Goog-SignedHeaders=host&X-Goog-Signature=109e3f4f9b367b0fe23e80267bac7badc20ec9e4e4232cb53c84574b648e329f5b0640b1c6988f5c0eaca272ed591af44fcb621a641052b8bfa01233ef462c7e05b76f67ca61bf817d1f681cc8a41caf6853a713634e98949b1045cd630fbe029a2e45f119881d57448995fcc586614589a288fe58ad2f6375c916027a84f60a685cd75e8e5feab912acfc34d478bc2bcb77da9e8700ed3d04c0836b37139cd191901c4561287152d17290f4aeb136656347654422a7bbe31a5292a4fc07b85a5040aafb79a7bc6b99e2f5b3275955d2cd49dc4f4b1790e5bc3c5669cb942cccfd5ed7ad61abf68ea0c8300ebe9a49356044d7e9395445bf1bd339d30a0312e6"
    "https://storage.googleapis.com/common-voice-prod-prod-datasets/cv-corpus-19.0-2024-09-13/cv-corpus-19.0-2024-09-13-zh-CN.tar.gz?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gke-prod%40moz-fx-common-voice-prod.iam.gserviceaccount.com%2F20241226%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20241226T011148Z&X-Goog-Expires=43200&X-Goog-SignedHeaders=host&X-Goog-Signature=34c75a376fe9ca7ffcc889f5cd618fc09cb224294bb90d0ba3829166b08909d45a187a367594ec7bb30a6da2b4b82f5afee2dcbe494a185e6bf3d737169946579222a4b87ec815721f290c6aad9042492afcb645e728c08d92c901be532897bc3a82526dbff3c949f2399b82daf2fc917ac7f610efc1a286830e183581e79746db84409e40f04cba3e25f5974ef1c144c272e50b8532b9d059c5ffa85718d8b0532ce3d052fa4d1866841f03bd20c9e2c2638e644e540e8aed9f7a77e92055de177d46f3d221033a514252ee7efc1bf69e6aad0c3b57b26e33bf1482a7eac4dce652184498397d02ed377411ca586b1f86ba8830641ab5ceedc7a3da640e8069"
)

echo "=== Preparing CommonVoice data for ${track} ==="

mkdir -p tmp

if [ ! -f "${output_dir}/download_commonvoice.done" ]; then
    # check if language id and URL are in the same order
    for i in "${!langs[@]}"; do
        lang="${langs[$i]}"
        URL="${URLs[$i]}"
        
        filename="cv-corpus-19.0-2024-09-13-${lang}.tar.gz"

        if [[ "$URL" != *"$filename"* ]]; then
            echo "Link to commonvoice ${lang} may be wrong."
            echo "Note that language IDs and corresponding URLs must be in the same order."
            exit 1
        fi
    done

    # download the commonvoice data
    # all 5 files are downloaded in parallel
    org_dir=${PWD}
    cd $output_dir
    for i in "${!langs[@]}"; do
        echo "${langs[$i]} ${URLs[$i]}"
    done | xargs -n 2 -P 5 bash -c '
        lang="$1"
        URL="$2"
        echo "Downloading for $lang"
        wget "$URL" -O "cv19.0-${lang}.tar.gz"
    ' _
    cd $org_dir

    touch "${output_dir}/download_commonvoice.done"
fi

for lang in de en es fr zh-CN; do
    # untar the .tar.gz file
    output_dir_lang="${output_dir}/cv-corpus-19.0-2024-09-13/${lang}"
    if [ ! -d "${output_dir_lang}/clips" ]; then
        echo "[CommonVoice-${lang}] extracting audio files from ${output_dir}/cv19.0-${lang}.tar.gz"
        # Please do not change "-m 1000"
        python ./utils/tar_extractor.py -m 1000 \
            -i ${output_dir}/cv19.0-${lang}.tar.gz \
            -o ${output_dir} \
            --skip_existing --skip_errors
    fi

    for split in train dev; do
        echo "=== Preparing CommonVoice ${lang} ${split} data ==="

        if [ $split == "train" ]; then
            split_track="${split}_${track}"
            split_name=$split_track
        else
            split_track=$split
            split_name=validation
        fi

        BW_EST_FILE="tmp/commonvoice_19.0_${lang}_${split_track}.json"
        if [ ! -f ${BW_EST_FILE} ]; then
            echo "[CommonVoice-${lang}] resolve file paths"

            # .json.gz file containing bandwidth information for the 1st-track data is provided
            BW_EST_FILE_JSON_GZ="./datafiles/commonvoice/commonvoice_19.0_${lang}_${split_track}.json.gz"
            gunzip -c $BW_EST_FILE_JSON_GZ > $BW_EST_FILE

            # BW_EST_FILE_TMP only has file names
            # Resolve the path here
            python utils/resolve_file_path.py \
                --audio_dir ${output_dir_lang}/clips \
                --json_file ${BW_EST_FILE} \
                --outfile ${BW_EST_FILE} \
                --audio_format mp3
        else
            echo "Estimated bandwidth file already exists. Delete ${BW_EST_FILE} if you want to re-estimate."
        fi

        RESAMP_SCP_FILE=tmp/commonvoice_19.0_${lang}_resampled_${split_track}.scp
        if [ ! -f ${RESAMP_SCP_FILE} ]; then
            echo "[CommonVoice-${lang}] resampling to estimated audio bandwidth"
            OMP_NUM_THREADS=1 python utils/resample_to_estimated_bandwidth.py \
            --bandwidth_data ${BW_EST_FILE} \
            --out_scpfile ${RESAMP_SCP_FILE} \
            --outdir "${output_dir_lang}/resampled/${split_track}" \
            --max_files 5000 \
            --nj 8 \
            --chunksize 1000
        else
            echo "Resampled scp file already exists. Delete ${RESAMP_SCP_FILE} if you want to re-resample."
        fi

        echo "[CommonVoice-${lang}] preparing data files"
        python utils/get_commonvoice_subset_split.py \
            --scp_path ${RESAMP_SCP_FILE} \
            --tsv_path "${output_dir_lang}/${split}.tsv" \
            --outfile commonvoice_19.0_${lang}_resampled_${split_name}.scp

        # "other" split is included in training data in track2
        if [ $split_track == "train_track2" ]; then
            python utils/get_commonvoice_subset_split.py \
                --scp_path ${RESAMP_SCP_FILE} \
                --tsv_path "${output_dir_lang}/other.tsv" \
                --outfile commonvoice_19.0_${lang}_resampled_other.scp
            
            cat commonvoice_19.0_${lang}_resampled_other.scp >> commonvoice_19.0_${lang}_resampled_${split_name}.scp
            rm commonvoice_19.0_${lang}_resampled_other.scp
            sort -k1 commonvoice_19.0_${lang}_resampled_${split_name}.scp -o commonvoice_19.0_${lang}_resampled_${split_name}.scp
        fi
            
        awk 'FNR==NR {arr[$2]=$1; next} {print($1" cv11_"arr[$1".mp3"])}' \
            "${output_dir_lang}/${split}.tsv" \
            commonvoice_19.0_${lang}_resampled_${split_name}.scp \
            > commonvoice_19.0_${lang}_resampled_${split_name}.utt2spk

        python utils/get_commonvoice_transcript.py \
            --audio_scp commonvoice_19.0_${lang}_resampled_${split_name}.scp \
            --tsv_path "${output_dir_lang}/${split}.tsv" \
            --outfile commonvoice_19.0_${lang}_resampled_${split_name}.text

    done
done

#--------------------------------
# Output file (for each ${lang} and ${track}):
# -------------------------------
# commonvoice_19.0_${lang}_resampled_train_${track}.scp
#    - scp file containing samples (after resampling) for training
# commonvoice_19.0_${lang}_resampled_train_${track}.utt2spk
#    - speaker mapping for training samples
# commonvoice_19.0_${lang}_resampled_train_${track}.text
#    - transcript for training samples
# commonvoice_19.0_${lang}_resampled_validation.scp
#    - scp file containing samples (after resampling) for validation
# commonvoice_19.0_${lang}_resampled_validation.utt2spk
#    - speaker mapping for validation samples
# commonvoice_19.0_${lang}_resampled_validation.text
#    - transcript for validation samples
