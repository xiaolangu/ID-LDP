# ID-LDP: Providing Input-Discriminative Protection for Local Differential Privacy

This is a sample code (in MATLAB) of our work [ID-LDP](https://arxiv.org/pdf/1911.01402.pdf) [ICDE' 20]

Local Differential Privacy (LDP) provides provable privacy protection for data collection without the assumption of the trusted data server. In the real-world scenario, different data have different privacy requirements due to the distinct sensitivity levels. However, LDP provides the same protection for all data. In this paper, we tackle the challenge of providing input-discriminative protection to reflect the distinct privacy requirements of different inputs. We first present the **Input-Discriminative LDP (ID-LDP)** privacy notion and focus on a specific version termed MinID-LDP, which is shown to be a finegrained version of LDP. Then, we focus on the application of frequency estimation and develop the IDUE mechanism based on Unary Encoding for single-item input and the extended mechanism IDUE-PS (with Padding-and-Sampling protocol) for item-set input. The results on both synthetic and real-world datasets validate the correctness of our theoretical analysis and show that the proposed mechanisms satisfying MinID-LDP have better utility than the state-of-the-art mechanisms satisfying LDP due to the input-discriminative protection.

## Implementation

The main function is PG1.m, which corresponds to the results in Fig. 3 of the paper. 
