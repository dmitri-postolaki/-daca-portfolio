"""
pipeline.py
UrbanStyle OÜ – automatiseeritud andmepipeline
Roll D: Automation Script
"""

import logging
import time

from data_fetcher import fetch_sales, fetch_customers
from transform import (
    clean_data,
    calculate_weekly_aggregates,
    calculate_kpis,
    merge_datasets,
)
from visualize_export import (
    create_weekly_chart,
    create_kpi_summary,
    export_results,
)

# Logimise seadistus
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)

logger = logging.getLogger(__name__)


def run_pipeline():
    """Käivitab UrbanStyle andmepipeline'i algusest lõpuni."""

    start_time = time.time()

    try:
        logger.info("Pipeline started")

        # 1. EXTRACT – andmete pärimine Supabase'ist
        logger.info("1/4 Andmete pärimine Supabase'ist...")

        df_sales = fetch_sales()
        df_customers = fetch_customers()

        if df_sales.empty:
            raise ValueError("Müügiandmete päring tagastas tühja DataFrame'i.")

        if df_customers.empty:
            raise ValueError("Kliendiandmete päring tagastas tühja DataFrame'i.")

        # 2. TRANSFORM – andmete puhastamine ja arvutused
        logger.info("2/4 Andmete töötlemine...")

        df_sales_clean = clean_data(df_sales)
        weekly = calculate_weekly_aggregates(df_sales_clean)
        kpis = calculate_kpis(df_sales_clean)
        merged = merge_datasets(df_sales_clean, df_customers)

        # Roll B ja Roll C väljundite nimetuste ühildamine
        if "sale_date" in weekly.columns and "week" not in weekly.columns:
            weekly = weekly.rename(columns={"sale_date": "week"})

        if "unique_customers" in weekly.columns and "customer_count" not in weekly.columns:
            weekly = weekly.rename(
                columns={"unique_customers": "customer_count"}
            )

        # 3. VISUALIZE – visualiseeringute loomine
        logger.info("3/4 Visualiseeringute loomine...")

        create_weekly_chart(weekly)
        create_kpi_summary(kpis)

        logger.info("Visualiseeringud loodud.")

        # 4. EXPORT – tulemuste salvestamine
        logger.info("4/4 Tulemuste eksportimine...")

        export_results(merged, weekly, kpis)

        elapsed = time.time() - start_time

        logger.info("Pipeline complete: %s rida töödeldud.", len(merged))
        logger.info("Kogu täitmisaeg: %.2f sekundit.", elapsed)

        print("\nPipeline completed successfully!")
        print(f"Töödeldud ridu: {len(merged)}")
        print(f"Täitmisaeg: {elapsed:.2f} sekundit")

    except Exception as error:
        logger.error("Pipeline failed: %s", error)
        print(f"\nPipeline failed: {error}")
        raise


if __name__ == "__main__":
    run_pipeline()
