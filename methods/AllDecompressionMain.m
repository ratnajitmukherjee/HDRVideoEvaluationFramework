function AllDecompressionMain(compressionmethod, read_path, width, height, nFrames, write_path, bitdepth, qp)
%% AllDecompressionMain:
% This function controls all the de-compression methods. Works as an entry
% point from where each decompression function works.
% NOTE: Stage Level Control: 2 

%% switchable command line for calling different de-compression methods.

    switch compressionmethod,        
        case 'hdrv',
            hdrv_Decode( read_path, width, height, nFrames, write_path, bitdepth);        
        case 'fraunhofer',
            fraunhofer_Decode( read_path, width, height, nFrames, write_path, bitdepth);        
        case 'pq'
            pq_Decode( read_path, width, height, nFrames, write_path, bitdepth);
        case 'pq_ipt'
            pq_ipt_Decode(read_path, width, height, nFrames, write_path, bitdepth);
        case 'tonemapping'
            tm_Decode( read_path, width, height, nFrames, write_path, bitdepth);
        case 'hvs'
            hvs_Decode( read_path, width, height, nFrames, write_path, bitdepth);
        case 'gamma2'
            g_param = 2.2;
            gamma8_Decode( read_path, width, height, nFrames, write_path, bitdepth, g_param);
        case 'gamma4'
            g_param = 4;
            gamma8_Decode( read_path, width, height, nFrames, write_path, bitdepth, g_param);
        case 'gamma6'
            g_param = 6;
            gamma8_Decode( read_path, width, height, nFrames, write_path, bitdepth, g_param);
        case 'gamma8'
            g_param = 8;
            gamma8_Decode( read_path, width, height, nFrames, write_path, bitdepth, g_param);
        case 'icam'
            iCAM_Decode( read_path, width, height, nFrames, write_path, bitdepth);
        case 'hdrmpeg'
            hdrmpeg_Decode(read_path, width, height, nFrames, write_path, qp);
        case 'hdrjpeg'
            hdrjpeg_Decode(read_path, width, height, nFrames, write_path, qp);
        case 'gohdr'
            gohdr_Decode(read_path, width, height, nFrames, write_path, qp);
        case 'rate'
            rate_Decode(read_path, width, height, nFrames, write_path, qp);
        case 'bbc'            
            bbc_Decode( read_path, width, height, nFrames, write_path, bitdepth);
            case 'bbc_hlg'            
            bbc_hlg_decode( read_path, width, height, nFrames, write_path, bitdepth);
        otherwise,
            error('Compression method ''%s'' unsupported!', compressionmethod);
    end 
end


