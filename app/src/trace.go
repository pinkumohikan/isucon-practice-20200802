package main

import (
	"log"
	"net/http"
	"os"

	"cloud.google.com/go/profiler"
	"contrib.go.opencensus.io/exporter/stackdriver"
	"contrib.go.opencensus.io/exporter/stackdriver/propagation"
	"contrib.go.opencensus.io/integrations/ocsql"
	"go.opencensus.io/plugin/ochttp"
	"go.opencensus.io/trace"
)

func initProfiler() {
	if err := profiler.Start(profiler.Config{
		Service:        "isucon3-20200802",
		ServiceVersion: "1.0.1",
		ProjectID:      os.Getenv("GOOGLE_CLOUD_PROJECT"),
	}); err != nil {
		log.Fatal(err)
	}
}

func initTrace() {
	exporter, err := stackdriver.NewExporter(stackdriver.Options{
		ProjectID:                os.Getenv("GOOGLE_CLOUD_PROJECT"),
		TraceSpansBufferMaxBytes: 32 * 1024 * 1024,
	})
	if err != nil {
		log.Fatal(err)
	}
	trace.RegisterExporter(exporter)

	//trace.ApplyConfig(trace.Config{DefaultSampler: trace.ProbabilitySampler(0.05)})
	trace.ApplyConfig(trace.Config{DefaultSampler: trace.AlwaysSample()})
}

func withTrace(h http.Handler) http.Handler {
	return &ochttp.Handler{Handler: h, Propagation: &propagation.HTTPFormat{}}
}

func tracedDriver(driverName string) string {
	driverName, err := ocsql.Register(driverName, ocsql.WithQuery(true), ocsql.WithQueryParams(true))
	if err != nil {
		log.Fatal(err)
	}
	return driverName
}
