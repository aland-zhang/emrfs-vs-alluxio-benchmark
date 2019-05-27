# emrfs-vs-alluxio-benchmark

> Uncompromised benchmark to understand the trade-off between [EMRFS](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-fs.html) and [Alluxio](https://www.alluxio.io/) for [Apache Spark](https://spark.apache.org/) applications with [Amazon S3](https://aws.amazon.com/s3/) persistence.

---

*Contents:* **[Environment](#Environment)** | **[Setup](#Setup)** | **[Workload](#Workload)** | **[Benchmark](#Benchmark)** | **[Result](#Result)**| **[Conclusion](#Conclusion)** | **[License](#License)**

---

## Environment

* EMR release: emr-5.23.0
* EBR root volume size: 10 GB
* Region: us-east-1
* Master Node: m4.2xlarge + 2 x EBS 32 GB GP2
* CORE Nodes: 10 x m4.4xlarge + 4 x EBS 32 GB GP2
* Apache Spark 2.4.0
* Python 3.6
* Alluxio 2.0.0-preview - ASYNC_THROUGH write type - CACHE_PROMOTE read type

## Setup

For both scenarios:
 - launch EMR cluster with the related bootstrap and config files.
 - Create and attach a EMR notebook in the cluster

For Alluxio, after launch the cluster, you need to give access for the Notebook user:

```sh
sudo su alluxio
/opt/alluxio/bin/alluxio fs mkdir /test
/opt/alluxio/bin/alluxio fs chown livy:livy /test
```

##Workload

* Input: 1 x Text file separated by pipes (|) generated by [TPC-H](http://www.tpc.org/tpch/) on S3 - 74 GB - 600 M records - 16 columns - No compression
* Output: 1000 x Parquet files on S3 - 27 GB - SNAPPY compression

## Benchmark

The benchmark routine measures the time elapsed to write the output (overwrite mode) and to read that.

It runs each routine 10x and extract tha minimum, maximum and average values.

P.S. The first read (From text file) and the first write (without overwrite) are ignored.

P.P.S The target Dataframe was cached to isolate the I/O performance. 

## Result

**Alluxio**

| Operation | Metric | Time (sec) |
|:---------:|:------:|:----------:|
|   write   |   min  |    80.2    |
|   write   |   avg  |    82.8    |
|   write   |   max  |    86.7    |
|    read   |   min  |    81.4    |
|    read   |   avg  |    86.0    |
|    read   |   max  |    91.6    |

**EMRFS**

| Operation | Metric | Time (sec) |
|:---------:|:------:|:----------:|
|   write   |   min  |    62.2    |
|   write   |   avg  |    67.4    |
|   write   |   max  |    77.7    |
|    read   |   min  |    94.3    |
|    read   |   avg  |    97.7    |
|    read   |   max  |    102.7   |

## Conclusion

* EMRFS writes faster than Alluxio
* Alluxio reads faster than EMRFS
* EMRFS provides the data on S3 immediately, Alluxio does not.
* Alluxio uses less CPU (Check Ganglia PDF files)
* EMRFS uses less memory (Check Ganglia PDF files)

## License

These codes/files are licensed under the MIT License. 
