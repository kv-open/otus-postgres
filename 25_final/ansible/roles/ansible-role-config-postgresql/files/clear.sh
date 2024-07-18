#! /bin/bash
echo -n "Подтвердите удаление кластера. (y/n)"
read item
case "$item" in
y|Y)
  systemctl stop postgresql@16-main.service
  rm -rf {{ postgres_data_directory }}/*
  rm -rf /var/lib/pgpro/tablespaces/*
  mkdir  -p \
    stf_ics_data \
    stf_ics_index \
    stf_ppa_data \
    stf_ppa_index \
    stf_ppa_data_trips \
    stf_ppa_index_trips \
    stf_ppa_data_trips_cott \
    stf_ppa_index_trips_cott \
    stf_slm_data \
    stf_slm_index \
    stf_ces_data \
    stf_ces_index \
    stf_cpr_data \
    stf_cpr_index \
    stf_das_data \
    stf_das_index \
    stf_eacm_data \
    stf_eacm_index \
    stf_eis_data \
    stf_eis_index \
    stf_fias_data \
    stf_fias_index \
    stf_fps_data \
    stf_fps_index \
    stf_iacm_data \
    stf_iacm_index \
    stf_ims_data \
    stf_ims_index \
    stf_kms_data \
    stf_kms_index \
    stf_lps_data \
    stf_lps_index \
    stf_mts_data \
    stf_mts_index \
    stf_pci_data \
    stf_pci_index \
    stf_pcr_data \
    stf_pcr_index \
    stf_pki_data \
    stf_pki_index \
    stf_rim_data \
    stf_rim_index \
    stf_sacm_data \
    stf_sacm_index \
    stf_scm_data \
    stf_scm_index \
    stf_tks_data \
    stf_tks_index \
    stf_tra_data \
    stf_tra_index \
    stf_vld_data \
    stf_vld_index \
    stf_dpk_data \
    stf_dpk_index \
    stf_tra_data_passes \
    stf_tra_index_passes \
    stf_tra_data_sales \
    stf_tra_index_sales \
    stf_ppa_trips_data \
    stf_ppa_trips_index \
    stf_ppa_trips_cott_data \
    stf_ppa_trips_cott_index \
    stf_tra_pass_data \
    stf_tra_pass_index \
    stf_tra_sale_data \
    stf_tra_sale_index \
    stf_das_clickhouse_data \
    stf_das_clickhouse_index \
    stf_ts_data \
    stf_ts_index \
    stf_admin_data \
    stf_admin_index

  ;;
n|N)
  echo "Операция очистки отменена"
  ;;
*) echo "Ничего не выбрано, очистка не произойдёт"
;;
esac
